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
    @IBOutlet weak var btnStartChat: UIButton!
    @IBOutlet weak var lblPublicationDate: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    
    private let userManager = UserManager()
    private var conversations = [ObjectConversation]()
    private let conversationManager = ConversationManager()
    private let announcementManager = AnnouncementManager()
    private var isMyAnnouncement = false

    var announcement:ObjectAnnouncement!
    var kingfisherSource:[KingfisherSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentID = userManager.currentUserID() else { return }
        isMyAnnouncement = currentID == announcement.userId!
        btnStartChat.setImage(UIImage(named: isMyAnnouncement ? "delete" : "send-message")  , for: .normal)
        userManager.currentUserData {[weak self] user in
            if let isMod = user?.isMod, isMod {
                self?.isMyAnnouncement = true
                self?.btnStartChat.setImage(UIImage(named: "delete")  , for: .normal)
            }
        }
        
        fetchConversations()
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
    
    func fetchConversations() {
        conversationManager.currentConversations {[weak self] conversations in
            self?.conversations = conversations.sorted(by: {$0.timestamp > $1.timestamp})
        }
    }
    
    @IBAction func didSelectToChat(_ sender: Any) {
        if isMyAnnouncement {
            announcementManager.delete(announcement) { _ in
                self.dismiss(animated: true) {
                    self.topMostViewController().showToast(message: "Excluído com sucesso!", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
                }
            }
        } else {
            guard let currentID = userManager.currentUserID() else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: MessagesContainerViewController = storyboard.instantiateViewController(withIdentifier: "ViewControllerChat") as! MessagesContainerViewController
            if let conversation = conversations.filter({$0.userIDs.contains(announcement.userId!)}).first {
                conversation.productId = announcement.id
                conversation.productName = announcement.title
                vc.conversation = conversation
                show(vc, sender: self)
                return
            }
            let conversation = ObjectConversation()
            conversation.productId = announcement.id
            conversation.productName = announcement.title
            conversation.userIDs.append(contentsOf: [currentID, announcement.userId!])
            conversation.isRead = [currentID: true, announcement.userId!: true]
            vc.conversation = conversation
            show(vc, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailsTableController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
