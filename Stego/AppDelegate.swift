//
//  AppDelegate.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let navigationController = UINavigationController()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)

        let rootViewController = RootViewController(nibName: "RootViewController", bundle: nil)

//        let storyboard = UIStoryboard.init(name: "Registration", bundle: nil)
////        if let rootVC = storyboard.instantiateInitialViewController() {
//        let rootVC = storyboard.instantiateViewController(withIdentifier: "Registration")
        
        navigationController.setViewControllers([rootViewController], animated: false)
//        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if let url: URL = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            _ = handleIncomingLink(url)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any?) -> Bool {
        
        if handleIncomingLink(url) {
            return true
        }
        
        return false
        
    }
    
    // MARK: - Handle links
    
    func handleIncomingLink(_ url: URL) -> Bool {
        
        print("\(type(of: self)) - \(#function): Handle incoming link: \(url)")
        
        if
            url.scheme?.hasPrefix("stego") == true,
            let code = url.queryItems["code"] {

            Api.accessCode = code
            Api.register()
        }
        
        return false
    }
}

