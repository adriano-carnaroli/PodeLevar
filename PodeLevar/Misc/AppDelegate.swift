//
//  AppDelegate.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 13/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirestoreService().configure()
        return true
    }

}

