//
//  AppDelegate.swift
//  Nudge
//
//  Created by Dylan Elliott on 23/5/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = .white
        navBarAppearance.shadowImage = UIImage()
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = UIImage()
        
        UITableView.appearance().backgroundColor = .white
        
        return true
    }
}

