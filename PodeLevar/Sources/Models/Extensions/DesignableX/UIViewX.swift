//
//  UIViewX.swift
//  DesignableX
//
//  Created by Mark Moeykens on 12/31/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewX: UIView {

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

    @IBInspectable var thirdColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }

    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }

    @IBInspectable var diagonalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var fadeInBottom: Bool = false
    @IBInspectable var fadeInBottomDelay: Double = 0.4

    override class var layerClass: AnyClass {
        {
            return CAGradientLayer.self
        }()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if fadeInBottom {
            transform = CGAffineTransform(translationX: 0, y: -20)
            alpha = 0
            UIView.animate(withDuration: 0.8, delay: fadeInBottomDelay, options: .allowUserInteraction, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
                self.fadeInBottom = false
            }, completion: nil)
        }
    }

    func updateView() {
        if let layer = self.layer as? CAGradientLayer {
            layer.colors = [ firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor ]

            if (horizontalGradient) {
                layer.startPoint = CGPoint(x: 0.0, y: 0.5)
                layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            } else if diagonalGradient {
                layer.startPoint = CGPoint(x: 0.0, y: 0.0)
                layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            } else {
                layer.startPoint = CGPoint(x: 0, y: 0)
                layer.endPoint = CGPoint(x: 0, y: 1)
            }
        }
    }

    // MARK: - Border

    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    // MARK: - Shadow

    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }

    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}
