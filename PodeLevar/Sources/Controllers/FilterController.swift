//
//  FilterController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 04/05/21.
//

import UIKit

struct FilterList {
    let state:String
    var cities:[String]
}

class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableState: UITableView!
    @IBOutlet weak var tableCity: UITableView!
    var allAnnouncements:[ObjectAnnouncement] = []
    var list:[FilterList] = []
    var onClick:((_ state:String, _ city:String) -> Void)?
    var selectedState = ""
    var selectedCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in allAnnouncements {
            if let index = list.firstIndex(where: { (aux) -> Bool in return item.state == aux.state }) {
                if !list[index].cities.contains(item.city!) {
                    list[index].cities.append(item.city!)
                }
            } else {
                list.append(FilterList(state: item.state!, cities: [item.city!]))
            }
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if tableCity == tableView {
            cell.accessoryType = .none
            let item = list.filter { $0.state == selectedState }
            if !item.isEmpty {
                cell.textLabel!.text = item.first!.cities[indexPath.row]
                if cell.textLabel!.text == selectedCity {
                    cell.accessoryType = .checkmark
                }
            }
        } else {
            cell.accessoryType = .none
            if list[indexPath.row].state == selectedState {
                cell.accessoryType = .checkmark
            }
            cell.textLabel!.text = list[indexPath.row].state
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableState {
            return list.count
        } else if !selectedState.isEmpty {
            let item = list.filter { $0.state == selectedState }
            return item.first!.cities.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableState {
            if selectedState != list[indexPath.row].state {
                selectedState = list[indexPath.row].state
                selectedCity = ""
                tableCity.reloadData()
            }
        } else {
            let item = list.filter { $0.state == selectedState }
            selectedCity = item.first!.cities[indexPath.row]
        }
        tableView.reloadData()
    }

    @IBAction func apply(_ sender: Any) {
        guard let click = self.onClick else { return }
        click(selectedState, selectedCity)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

}
