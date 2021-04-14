//
//  UILabelX.swift
//  DesignableXTesting
//
//  Created by Mark Moeykens on 1/28/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class UILabelX: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }

    // MARK: - Shadow Text Properties

    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }

    @IBInspectable public var shadowColorLayer: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColorLayer.cgColor
        }
    }

    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable public var shadowOffsetLayer: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetLayer
        }
    }

    // MARK: - Animations
    @IBInspectable var pulseDelay: Double = 0.0

    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4

    @IBInspectable var fadeInBottom: Bool = false
    @IBInspectable var fadeInBottomDelay: Double = 0.4

    @IBInspectable var typingEfect: Bool = false
    @IBInspectable var typingEfectDelay: Double = 0.4

    override func awakeFromNib() {
        if pulseDelay > 0 {
            UIView.animate(withDuration: 1, delay: pulseDelay, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }

        if popIn {
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }

        if fadeInBottom {
            transform = CGAffineTransform(translationX: 0, y: -40)
            alpha = 0
            UIView.animate(withDuration: 0.8, delay: fadeInBottomDelay, options: .allowUserInteraction, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }

        if typingEfect {
            let textCopy = text!
            text = String.empty()
            UIView.animate(withDuration: 0, delay: 0, options: .allowUserInteraction, animations: {}, completion: { (_) in
                for char in textCopy {
                    // AudioServicesPlaySystemSound(1306) // Sound Library: https://github.com/TUNER88/iOSSystemSoundsLibrary
                    self.text! += "\(char)"
                    RunLoop.current.run(until: Date() + 0.08)
                }
            })
        }
    }

}
