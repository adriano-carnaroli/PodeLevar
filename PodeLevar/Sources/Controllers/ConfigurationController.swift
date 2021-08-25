//
//  ConfigurationController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 14/07/21.
//

import UIKit
import Kingfisher
import ImageSlideshow

class ConfigurationController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

class ConfigurationTableController: UITableViewController {

    @IBOutlet var slideshowImgProfile: ImageSlideshow!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    private let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideshowImgProfile.contentScaleMode = UIViewContentMode.scaleAspectFill
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsTableController.didTap))
        slideshowImgProfile.addGestureRecognizer(recognizer)
        
        userManager.currentUserData {[weak self] user in
            if let userName = user?.name, let email = user?.email {
                self?.lblName.text = userName.uppercased()
                self?.lblEmail.text = email
                if let imageUrl = user?.profilePicLink {
                    self?.slideshowImgProfile.setImageInputs([KingfisherSource(urlString: imageUrl)!])
                } else {
                    self?.slideshowImgProfile.setImageInputs([ImageSource(image: UIImage(named: "profile pic")!)])
                }
            } else {
                self?.showError()
            }
        }
    }

    @objc func didTap() {
        let fullScreenController = slideshowImgProfile.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @IBAction func showMyAnnouncements(_ sender: UIButton) {
        parent?.performSegue(withIdentifier: "segueMyAnnouncements", sender: nil)
    }
    
    func showError() {
        showToast(message: "Erro ao recuperar informações do usuário.", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("teste")
    }

}
