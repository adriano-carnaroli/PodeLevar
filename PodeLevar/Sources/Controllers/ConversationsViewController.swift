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
//  ConversationsViewController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 17/08/21.
//

import UIKit

class ConversationsViewController: UIViewController {

    private let manager = ConversationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MessagesContainerViewController {
            vc.conversation = sender as! ObjectConversation
            manager.markAsRead(sender as! ObjectConversation)
        }
    }

}

class ConversationsTableViewController: UITableViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    private let segueChat = "segueChat"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .default
    }
    
    //MARK: Private properties
    private var conversations = [ObjectConversation]()
    private let manager = ConversationManager()
    private let userManager = UserManager()
    private var currentUser: ObjectUser?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      fetchProfile()
      fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
  }

  //MARK: Private methods
  extension ConversationsTableViewController {
    
    func fetchConversations() {
      manager.currentConversations {[weak self] conversations in
        self?.conversations = conversations.sorted(by: {$0.timestamp > $1.timestamp})
        self?.tableView.reloadData()
        self?.playSoundIfNeeded()
      }
    }
    
    func fetchProfile() {
      userManager.currentUserData {[weak self] user in
        self?.currentUser = user
        if let urlString = user?.profilePicLink {
          //self?.profileImageView.setImage(url: URL(string: urlString))
        }
      }
    }
    
    func playSoundIfNeeded() {
      guard let id = userManager.currentUserID() else { return }
      if conversations.last?.isRead[id] == false {
        AudioService().playSound()
      }
    }
  }

  //MARK: UITableView Delegate & DataSource
  extension ConversationsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if conversations.isEmpty {
        return 1
      }
      return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard !conversations.isEmpty else {
        return tableView.dequeueReusableCell(withIdentifier: "EmptyCell")!
      }
      let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.className) as! ConversationCell
      cell.set(conversations[indexPath.row])
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if conversations.isEmpty {
        //composePressed(self)
        return
      }
        self.parent?.performSegue(withIdentifier: segueChat, sender: conversations[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if conversations.isEmpty {
        return tableView.bounds.height - 50 //header view height
      }
      return 80
    }
  }
