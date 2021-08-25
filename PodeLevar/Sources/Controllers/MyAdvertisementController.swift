//
//  MyAdvertisementController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 20/08/21.
//

import UIKit

class MyAdvertisementController: UIViewController {

    var allAnnouncements:[ObjectAnnouncement] = []
    private var childController:AdvertisementTableController!
    private let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLblFilter()
    }

    func showError() {
        showToast(message: "Erro ao recuperar dados", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
    }
    
    func updateLblFilter() {
        var filterList = allAnnouncements
        guard let userID = userManager.currentUserID() else { showError(); return }
        filterList = filterList.filter { obj in
            return obj.userId == userID
        }
        childController.announcements = filterList
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AdvertisementTableController {
            childController = controller
        } else if let controller = segue.destination as? DetailsController {
            controller.announcement = sender as? ObjectAnnouncement
        }
    }

}
