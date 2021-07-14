//
//  LoginController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 13/04/21.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RegisterController {
            controller.loginController = self
        }
    }
}

class LoginTableController: UITableViewController {
    //MARK: IBOutlets
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!

    //MARK: Private properties
    private var selectedImage: UIImage?
    private let manager = UserManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEnableHideKeyboardWhenTapped()
        self.parent?.setEnableHideKeyboardWhenTapped()
    }
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginEmailTextField.text = "ross@teste.com"
        loginPasswordTextField.text = "teste123"
    }
 
    @IBAction func login(_ sender: Any) {
      guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
        return
      }
      guard email.isValidEmail() else {
        //separatorViews.filter({$0.tag == 0}).first?.backgroundColor = .red
        return
      }
      guard password.count > 5 else {
        //separatorViews.filter({$0.tag == 1}).first?.backgroundColor = .red
        return
      }
      view.endEditing(true)
      let user = ObjectUser()
      user.email = email
      user.password = password
      showLoading(true)
      manager.login(user: user) {[weak self] response in
        ThemeService.showLoading(false)
        switch response {
        case .failure: self?.showAlert()
        case .success: self?.parent?.performSegue(withIdentifier: "segueToMain", sender: nil)
        }
      }
    }
}

  //MARK: UITextField Delegate
extension LoginTableController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
