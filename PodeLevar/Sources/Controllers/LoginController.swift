//
//  LoginController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 13/04/21.
//

import UIKit

class LoginController: UIViewController {
    
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
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEnableHideKeyboardWhenTapped()
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        self.parent?.setEnableHideKeyboardWhenTapped()
    }
 
    @IBAction func login(_ sender: Any) {
        guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else { return }
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
        user.email = email
        user.password = password
        showLoading(true)
        manager.login(user: user) {[weak self] response in
            ThemeService.showLoading(false)
            switch response {
            case .failure: self?.showAlert(message: "Não foi possível autenticar, verifique se os dados informados estão corretos.")
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
