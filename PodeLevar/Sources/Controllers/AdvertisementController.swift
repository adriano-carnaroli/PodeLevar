//
//  AdvertisementController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 18/04/21.
//

import UIKit
import Kingfisher

class AdvertisementController: UIViewController {

    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lblFilter: UILabel!
    var allAnnouncements:[ObjectAnnouncement] = []
    var selectedState = ""
    var selectedCity = ""
    private var childController:AdvertisementTableController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLblFilter()
    }

    func updateLblFilter() {
        var filterList = allAnnouncements
        if !selectedState.isEmpty {
            if !selectedCity.isEmpty {
                filterList = filterList.filter { obj in
                    return obj.city == selectedCity && obj.state == selectedState
                }
            } else {
                filterList = filterList.filter { obj in
                    return obj.state == selectedState
                }
            }
        }
        childController.announcements = filterList
        childController.tableView.reloadData()
        lblFilter.text = "Local: \(selectedState.isEmpty ? "Todos" : selectedState)\(selectedCity.isEmpty ? "" : " - \(selectedCity)") \nEncontramos \(filterList.count) ite\(filterList.count > 1 ? "ns" : "m")"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailsController {
            controller.announcement = sender as? ObjectAnnouncement
        } else if let controller = segue.destination as? FilterController {
            controller.allAnnouncements = self.allAnnouncements
            controller.onClick = { (state, city) in
                self.selectedState = state
                self.selectedCity = city
                self.updateLblFilter()
            }
        } else if let controller = segue.destination as? AdvertisementTableController {
            childController = controller
        }
    }

}

class AdvertisementTableController: UITableViewController {

    var announcements:[ObjectAnnouncement] = []
    private let manager = AnnouncementManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getAll { [weak self] (list) in
            let sortedList = list.sorted {
                $0.insertDate! > $1.insertDate!
            }
            self?.announcements = sortedList
            if let parent = self?.parent as? AdvertisementController {
                parent.btnFilter.isHidden = sortedList.isEmpty
                parent.allAnnouncements = sortedList
                parent.updateLblFilter()
            } else if let parent = self?.parent as? MyAdvertisementController {
                parent.allAnnouncements = sortedList
                parent.updateLblFilter()
            }
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if announcements.isEmpty {
            return tableView.bounds.height - 50
        }
        return 117
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if announcements.isEmpty {
          return 1
        }
        return announcements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !announcements.isEmpty else {
          return tableView.dequeueReusableCell(withIdentifier: "EmptyCell")!
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdvertisementCell.identifier, for: indexPath) as? AdvertisementCell else { return UITableViewCell() }
        let add = announcements[indexPath.row]
        cell.lblTitle.text = add.title
        cell.lblDescription.text = add.description
        let url = URL(string: add.announcementPicsLink![0])
        cell.imgPicture.kf.setImage(with: url)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if announcements.isEmpty { return }
        let item = announcements[indexPath.row]
        self.parent?.performSegue(withIdentifier: "segueDetails", sender: item)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
