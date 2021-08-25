//
//  UIViewController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 17/04/21.
//

import UIKit
import ALLoadingView
import Toast_Swift

extension UIViewController {
    func showLoading(_ status: Bool)  {
        if status {
            ALLoadingView.manager.messageText = ""
            ALLoadingView.manager.animationDuration = 1.0
            ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
            return
        }
        ALLoadingView.manager.hideLoadingView()
    }
    
    func topMostViewController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }else{
            return self
        }
    }

    public func showToast(message:String, title:String?, image:UIImage?, tapCloseToast:(() -> Void)?, closeAutoToast:(() -> Void)?) {
        // create a new style
        var style = ToastStyle()

        style.cornerRadius = 4
        style.messageAlignment = .left
        style.maxWidthPercentage = 1.0

        // this is just one of many style options
        style.messageColor = .white

        // present the toast with the new style
        self.view.makeToast(message, duration: 2.0, position: .bottom, title: title, image: image, style: style) { (tapClose) in
            if tapClose {
                guard let block = tapCloseToast else {return}
                block()
            } else {
                guard let block = closeAutoToast else {return}
                block()
            }
        }
        // toggle "tap to dismiss" functionality
        ToastManager.shared.isTapToDismissEnabled = true

    }
    
    func setEnableHideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
