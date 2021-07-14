//
//  DetailsController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 02/05/21.
//

import UIKit
import ImageSlideshow

class DetailsController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    var announcement:ObjectAnnouncement!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = announcement.title
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailsTableController {
            controller.announcement = self.announcement
        }
    }

}

class DetailsTableController: UITableViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLocalization: UILabel!
    @IBOutlet weak var lblAdvertiser: UILabel!
    @IBOutlet weak var lblPublicationDate: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!

    var announcement:ObjectAnnouncement!
    var kingfisherSource:[KingfisherSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for url in announcement.announcementPicsLink! {
            kingfisherSource.append(KingfisherSource(urlString: url)!)
        }
        lblDescription.text = announcement.description
        lblLocalization.text = "\(announcement.district ?? ""), \(announcement.city ?? "")/\(announcement.state ?? "") - \(announcement.zipcode!)"
        lblAdvertiser.text = announcement.userName
        lblPublicationDate.text = "Publicado em \(announcement.insertDate!.dateFormatter(patternInput: "yyyy-MM-dd HH:mm:ss", patternOutput: "dd/MM 'às' HH:mm"))"
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.pageIndicator = UIPageControl.withSlideshowColors()
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        slideshow.setImageInputs(kingfisherSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsTableController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }

    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
}

extension DetailsTableController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
