//
//  AppDelegate.swift
//  Nudge
//
//  Created by Dylan Elliott on 23/5/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit
import Chameleon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tintColour: UIColor = .flatSkyBlue
        let bgColour: UIColor = .white
        
        window!.tintColor = tintColour
        
        let switchAppearance = UISwitch.appearance()
        switchAppearance.onTintColor = tintColour
        
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = bgColour
        navBarAppearance.shadowImage = UIImage()
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundColor = bgColour
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = UIImage()
        
        UITableView.appearance().backgroundColor = bgColour
        
        return true
    }
}

