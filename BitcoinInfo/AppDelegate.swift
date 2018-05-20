//
//  AppDelegate.swift
//  BitcoinInfo
//
//  Created by MacBook on 18.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let InfoAboutCourceVC = InfoAboutCourseViewController()
        let InfoAboutTransactionVC = InfoAboutTransactionViewController()
        let ConvertcCurrencyVC = ConvertCurrencyToBitViewController()
        
        InfoAboutCourceVC.tabBarItem = UITabBarItem(title: "Chart", image: #imageLiteral(resourceName: "course"), tag: 0)
        InfoAboutTransactionVC.tabBarItem = UITabBarItem(title: "Transaction", image: #imageLiteral(resourceName: "transaction"), tag: 1)
        ConvertcCurrencyVC.tabBarItem = UITabBarItem(title: "Convert", image: #imageLiteral(resourceName: "convert"), tag: 2)
        
        let InfoAboutCourseNav = UINavigationController(rootViewController: InfoAboutCourceVC)
        let InfoAboutTransactionNav = UINavigationController(rootViewController: InfoAboutTransactionVC)
        let ConvertcCurrencyNav = UINavigationController(rootViewController: ConvertcCurrencyVC)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        tabBarController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.4999483824, green: 0.50003618, blue: 0.4999368191, alpha: 1)
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.1722841263, green: 0.343290329, blue: 0.9279283285, alpha: 1)
        InfoAboutTransactionVC.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.968627451, alpha: 1)
        InfoAboutTransactionVC.navigationItem.title = "Transaction"
        tabBarController.setViewControllers([InfoAboutCourseNav,InfoAboutTransactionNav,ConvertcCurrencyNav], animated: true)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
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


}

