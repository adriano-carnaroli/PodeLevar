//
//  DesignableUITextField.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/16/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

@IBDesignable
class UITextFieldX: JMMaskTextField {

    @IBInspectable var pasteAction:Bool = true
    @IBInspectable private var selectAction:Bool = true
    @IBInspectable private var selectAllAction:Bool = true

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }

    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }

    @IBInspectable var placeholderColor: UIColor = .white {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                         attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    private var _isRightViewVisible: Bool = true
    var isRightViewVisible: Bool {
        get {
            return _isRightViewVisible
        }
        set {
            _isRightViewVisible = newValue
            updateView()
        }
    }

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

    func updateView() {
        setLeftImage()
        setRightImage()
        self.setNeedsDisplay()
    }

    func getPlaceholder() -> NSAttributedString {
        return NSAttributedString(string: self.placeholder ?? "",
                                  attributes:[NSAttributedString.Key.foregroundColor: UIColor.init(hexString: ColorsHex.brownGrey)])
    }

    func setLeftImage() {
        leftViewMode = UITextField.ViewMode.always
        var view: UIView

        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in
            // the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = tintColor

            var width = imageView.frame.width + leftPadding

            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }

            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 20))
        }

        leftView = view
    }

    func setRightImage() {
        rightViewMode = UITextField.ViewMode.always

        var view: UIView

        if let image = rightImage, isRightViewVisible {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image
            // in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = tintColor

            var width = imageView.frame.width + rightPadding

            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }

            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)

        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 20))
        }

        rightView = view
    }

    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
