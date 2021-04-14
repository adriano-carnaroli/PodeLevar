//
//  ViewControllerX.swift
//  002 - Credit Card Checkout
//
//  Created by Mark Moeykens on 1/4/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewControllerX: UIViewController {

    @IBInspectable var lightStatusBar: Bool = false
    @IBInspectable var darkenBackgroundImage: Bool = false
    @IBOutlet weak var imgBackground: UIImageViewX!
    @IBOutlet weak var imgLogo: UIImageViewX!
    @IBOutlet weak var titleLabel: UILabelX!
    @IBOutlet weak var backButton: UIButtonX!
    @IBOutlet weak var lblEnv: UILabel!
    @IBOutlet weak var viewEnv: UIViewX!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        {
            if lightStatusBar {
                return UIStatusBarStyle.lightContent
            } else {
                return UIStatusBarStyle.default
            }
        }()
    }

}
