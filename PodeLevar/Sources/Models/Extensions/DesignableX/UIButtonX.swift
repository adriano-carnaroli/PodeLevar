//
//  DesignableButton.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/18/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton {

    var isButtonEnable:Bool = false {
        willSet {
            isEnabled = newValue
            backgroundColor = newValue ? Constants.buttonColor : Constants.buttonDisabledColor
            setTitleColor(newValue ? .white : Constants.textDisableColor, for: .normal)
            setNeedsDisplay()
        }
    }

    enum FromDirection:Int {
        case top = 0
        case right = 1
        case bottom = 2
        case left = 3
    }

    var shadowView: UIView!
    var direction: FromDirection = .left
    var alphaBefore: CGFloat = 1
    var backPressed = false

    @IBInspectable var backButton: Bool = false
    @IBInspectable var popRootViewController:Bool = false
    @IBInspectable var dismissTwoViewControllers:Bool = false
    @IBInspectable var dismissToController: String = String.empty()
    @IBInspectable var skipController: String = String.empty()

    @IBInspectable var animate: Bool = false
    @IBInspectable var animateDelay: Double = 0.2
    @IBInspectable var animateFrom: Int {
        get {
            return direction.rawValue
        }
        set (directionIndex) {
            direction = FromDirection(rawValue: directionIndex) ?? .left
        }
    }

    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4

    @IBInspectable var fadeInBottom: Bool = false
    @IBInspectable var fadeInBottomDelay: Double = 0.4

    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        backPressed = false
        if backButton {
            inititalize()
            backButton = false
        }

        if fadeInBottom {
            transform = CGAffineTransform(translationX: 0, y: -20)
            alpha = 0
            UIView.animate(withDuration: 0.8, delay: fadeInBottomDelay, options: .allowUserInteraction, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                self.fadeInBottom = false
            }, completion: nil)
        }

        if animate {
            let originalFrame = frame

            if direction == .bottom {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y + 200, width: frame.width, height: frame.height)
            }

            UIView.animate(withDuration: 0.3, delay: animateDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.frame = originalFrame
            }, completion: nil)
        }

        if popIn {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }

        if shadowView == nil && shadowOpacity > 0 {
            shadowView = UIView(frame: self.frame)
            shadowView.backgroundColor = UIColor.clear
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowOpacity = Float(shadowOpacity)
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.layer.masksToBounds = true
            shadowView.clipsToBounds = false

            self.superview?.addSubview(shadowView)
            self.superview?.bringSubviewToFront(self)
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha

        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0.4
        })

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = self.alphaBefore
        })
    }

    // MARK: - Borders

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    // MARK: - Shadow

    @IBInspectable public var shadowOpacity: CGFloat = 0
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowRadius: CGFloat = 0
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0)

   // MARK: - Gradient
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }

    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }

    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }

    override public class var layerClass: AnyClass {
        {
            return CAGradientLayer.self
        }()
    }

    func updateView() {
        if let layer = self.layer as? CAGradientLayer {
            layer.colors = [ firstColor.cgColor, secondColor.cgColor ]

            if (horizontalGradient) {
                layer.startPoint = CGPoint(x: 0.0, y: 0.5)
                layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            } else {
                layer.startPoint = CGPoint(x: 0, y: 0)
                layer.endPoint = CGPoint(x: 0, y: 1)
            }
        }
    }

    var overrideBackEvent:(() -> Void)?

    func inititalize() {
        self.addTarget(self, action: #selector(back), for:.touchDown)
    }

   @objc func back() {
        backPressed = true
       if let overrideBlockEvent = overrideBackEvent {
           overrideBlockEvent()
           return
       }
       if let navigation = self.parentViewController?.navigationController {
           if popRootViewController {
               navigation.popToRootViewController(animated: true)
           } else {
               if navigation.viewControllers.first == self.parentViewController {
                   let viewC =  navigation.viewControllers.first
                   viewC?.dismiss(animated: true, completion: nil)
               } else if navigation.topViewController == self.parentViewController {
                   navigation.popViewController(animated: true)
               }
           }
       } else {
            dismissModal()
       }
   }

    var typeName: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }

    func dismissModal() {
        guard let controller =  self.parentViewController else { return }
        controller.dismiss(animated: true, completion: nil)
    }
}
