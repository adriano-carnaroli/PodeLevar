//  MIT License

//  Copyright (c) 2019 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  MessagesViewController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 17/08/21.
//

import UIKit

class MessagesContainerViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    
    var conversation = ObjectConversation()
    
    override func viewDidLoad() {
        fetchUserName()
    }
    
    private func fetchUserName() {
      guard let currentUserID = UserManager().currentUserID() else { return }
      guard let userID = conversation.userIDs.filter({$0 != currentUserID}).first else { return }
      UserManager().userData(for: userID) {[weak self] user in
        guard let name = user?.name else { return }
        self?.lblName.text = name.capitalized
      }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MessagesViewController {
            vc.conversation = conversation
        }
    }
}

class MessagesViewController: UIViewController, KeyboardHandler {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var barBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var actionButtons: [UIButton]!

    //MARK: Private properties
    private let manager = MessageManager()
    private let imageService = ImagePickerService()
    private let locationService = LocationService()
    private var messages = [ObjectMessage]()
    
    //MARK: Public properties
    var conversation = ObjectConversation()
    var bottomInset: CGFloat {
      return view.safeAreaInsets.bottom + 50
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      addKeyboardObservers() {[weak self] state in
        guard state else { return }
        self?.tableView.scroll(to: .bottom, animated: true)
      }
      fetchMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.scroll(to: .bottom, animated: true)
    }
  }

  //MARK: Private methods
  extension MessagesViewController {
    
    private func fetchMessages() {
      manager.messages(for: conversation) {[weak self] messages in
        let sortedMessages = messages.sorted(by: {$0.timestamp < $1.timestamp})
        var lastProduct = ""
        for message in sortedMessages {
            if lastProduct != message.productName {
                lastProduct = message.productName ?? ""
            } else {
                message.productName = ""
            }
        }
        self?.messages = sortedMessages
        self?.tableView.reloadData()
        self?.tableView.scroll(to: .bottom, animated: true)
      }
    }
    
    private func send(_ message: ObjectMessage) {
      manager.create(message, conversation: conversation) {[weak self] response in
        guard let weakSelf = self else { return }
        if response == .failure {
          weakSelf.showAlert()
          return
        }
        weakSelf.conversation.timestamp = Int(Date().timeIntervalSince1970)
        switch message.contentType {
        case .none: weakSelf.conversation.lastMessage = message.message
        case .photo: weakSelf.conversation.lastMessage = "Imagem"
        case .location: weakSelf.conversation.lastMessage = "Localização"
        default: break
        }
        if let currentUserID = UserManager().currentUserID() {
          weakSelf.conversation.isRead[currentUserID] = true
        }
        ConversationManager().create(weakSelf.conversation)
      }
    }
    
    private func showActionButtons(_ status: Bool) {
      guard !status else {
        stackViewWidthConstraint.constant = 112
        UIView.animate(withDuration: 0.3) {
          self.expandButton.isHidden = true
          self.expandButton.alpha = 0
          self.actionButtons.forEach({$0.isHidden = false})
          self.view.layoutIfNeeded()
        }
        return
      }
      guard stackViewWidthConstraint.constant != 32 else { return }
      stackViewWidthConstraint.constant = 32
      UIView.animate(withDuration: 0.3) {
        self.expandButton.isHidden = false
        self.expandButton.alpha = 1
        self.actionButtons.forEach({$0.isHidden = true})
        self.view.layoutIfNeeded()
      }
    }
  }

  //MARK: IBActions
  extension MessagesViewController {
    
    @IBAction func sendMessagePressed(_ sender: Any) {
      guard let text = inputTextField.text, !text.isEmpty else { return }
      let message = ObjectMessage()
      message.message = text
      message.productId = conversation.productId
      message.productName = conversation.productName
      message.ownerID = UserManager().currentUserID()
      inputTextField.text = nil
      showActionButtons(false)
      send(message)
    }
    
    @IBAction func sendImagePressed(_ sender: UIButton) {
      imageService.pickImage(from: self, allowEditing: false, source: sender.tag == 0 ? .photoLibrary : .camera) {[weak self] image in
        let message = ObjectMessage()
        message.contentType = .photo
        message.productId = self?.conversation.productId
        message.productName = self?.conversation.productName
        message.profilePic = image
        message.ownerID = UserManager().currentUserID()
        self?.send(message)
        self?.inputTextField.text = nil
        self?.showActionButtons(false)
      }
    }
    
    @IBAction func sendLocationPressed(_ sender: UIButton) {
      locationService.getLocation {[weak self] response in
        switch response {
        case .denied:
          self?.showAlert(title: "Error", message: "Por favor habilite os serviços de localização")
        case .location(let location):
          let message = ObjectMessage()
          message.productId = self?.conversation.productId
          message.productName = self?.conversation.productName
          message.ownerID = UserManager().currentUserID()
          message.content = location.string
          message.contentType = .location
          self?.send(message)
          self?.inputTextField.text = nil
          self?.showActionButtons(false)
        }
      }
    }
    
    @IBAction func expandItemsPressed(_ sender: UIButton) {
      showActionButtons(true)
    }
  }

  //MARK: UITableView Delegate & DataSource
  extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let message = messages[indexPath.row]
      if message.contentType == .none {
        let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == UserManager().currentUserID() ? "MessageTableViewCell" : "UserMessageTableViewCell") as! MessageTableViewCell
        cell.set(message)
        cell.lblProductHeightConstraint.constant = (message.productName ?? "") == "" ? 0 : 20
        return cell
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: message.ownerID == UserManager().currentUserID() ? "MessageAttachmentTableViewCell" : "UserMessageAttachmentTableViewCell") as! MessageAttachmentTableViewCell
      cell.delegate = self
      cell.set(message)
      cell.lblProductHeightConstraint.constant = (message.productName ?? "") == "" ? 0 : 20
      return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      guard tableView.isDragging else { return }
      cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      UIView.animate(withDuration: 0.3, animations: {
        cell.transform = CGAffineTransform.identity
      })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let message = messages[indexPath.row]
      switch message.contentType {
      case .location:
        let vc: MapPreviewController = UIStoryboard.controller(storyboard: .previews)
        vc.locationString = message.content
        self.present(vc, animated: true)
      case .photo:
        let vc: ImagePreviewController = UIStoryboard.controller(storyboard: .previews)
        vc.imageURLString = message.profilePicLink
        self.present(vc, animated: true)
      default: break
      }
    }
  }

  //MARK: UItextField Delegate
  extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      showActionButtons(false)
      return true
    }
  }

  //MARK: MessageTableViewCellDelegate Delegate
  extension MessagesViewController: MessageTableViewCellDelegate {
    
    func messageTableViewCellUpdate() {
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }

