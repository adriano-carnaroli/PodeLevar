//
//  UIView.swift
//
//  Created by Adriano Carnaroli.
//  Copyright © 2021 Adriano Carnaroli. All rights reserved.
//

import UIKit

extension UIView {

    public enum UIViewBorderSide {
        case top, bottom, left, right
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    public func addBorder(side: UIViewBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch side {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        self.layer.addSublayer(border)
    }

    public func setDegradView(colorTop:UIColor, colorBotton:UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.layer.frame.width, height: self.layer.frame.height))
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [colorTop.cgColor, colorBotton.cgColor]

        self.layer.insertSublayer(gradient, at: 0)
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context =  UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = image else { return nil }
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        return newImage
    }

    func disableAllClipsToBounds(to view:UIView?, disable:Bool? = true) {
        guard let currentView = view else {
            return
        }
        currentView.clipsToBounds = !disable!
        disableAllClipsToBounds(to: currentView.superview)
    }

    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }

    func constraintsWithIdentifier(_ identifier: String) -> [NSLayoutConstraint] {
        return self.constraints.filter { $0.identifier == identifier }
    }

    func recursiveConstraintsWithIdentifier(_ identifier: String) -> [NSLayoutConstraint] {
        var constraintsArray: [NSLayoutConstraint] = []

        var subviews: [UIView] = [self]

        while !subviews.isEmpty {
            constraintsArray += subviews.flatMap { $0.constraintsWithIdentifier(identifier) }
            subviews = subviews.flatMap { $0.subviews }
        }

        return constraintsArray
    }

}
