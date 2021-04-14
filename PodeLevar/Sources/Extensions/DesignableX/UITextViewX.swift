//
//  UITextViewX.swift
//  S3BankiOS
//
//  Created by Adriano Carnaroli on 19/02/21.
//  Copyright © 2021 S3 Bank. All rights reserved.
//

import UIKit

@IBDesignable
class UITextViewX: UITextView {

    @IBInspectable var pasteAction:Bool = true
    @IBInspectable private var selectAction:Bool = true
    @IBInspectable private var selectAllAction:Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return self.pasteAction
        }
        if action == #selector(UIResponderStandardEditActions.select(_:)) {
            return self.selectAction
        }
        if action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return self.selectAllAction
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
