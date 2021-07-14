//
//  RegisterController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 18/04/21.
//

import UIKit

class RegisterController: UIViewController {
    var loginController: LoginController!
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

}

class RegisterTableController: UITableViewController {
    //MARK: IBOutlets
    @IBOutlet weak var registerImageView: UIImageView!
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!

    //MARK: Private properties
    private var selectedImage: UIImage?
    private let manager = UserManager()
    private let imageService = ImagePickerService()
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEnableHideKeyboardWhenTapped()
        self.parent?.setEnableHideKeyboardWhenTapped()
    }
    
    @IBAction func register(_ sender: Any) {
      guard let name = registerNameTextField.text, let email = registerEmailTextField.text, let password = registerPasswordTextField.text else {
        return
      }
      guard !name.isEmpty else {
        showToast(message: "Nome é obrigatório", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
        return
      }
      guard email.isValidEmail() else {
        showToast(message: "E-mail inválido", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
        return
      }
      guard password.count > 5 else {
        showToast(message: "Senha deve ter ao menos 6 caracteres", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
        return
      }
      view.endEditing(true)
      let user = ObjectUser()
      user.name = name
      user.email = email
      user.password = password
      user.profilePic = selectedImage
      ThemeService.showLoading(true)
      manager.register(user: user) {[weak self] response in
        ThemeService.showLoading(false)
        switch response.status {
          case .failure:
            if let msg = response.errorString {
                self?.showAlert(message:msg)
            } else {
                self?.showAlert()
            }
          case .success:
            (self!.parent as! RegisterController).loginController.showToast(message: "Cadastrado com sucesso!", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
            self?.dismiss(animated: true, completion: nil)
        }
      }
    }
    
    @IBAction func profileImage(_ sender: Any) {
        imageService.pickImage(from: self) {[weak self] image in
            self?.registerImageView.image = image
            self?.selectedImage = image
        }
    }

}

extension RegisterTableController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
