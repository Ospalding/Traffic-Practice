//
//  AppDelegate.swift
//  WhichWay _v1
//
//  Created by Oliver Spalding on 11/2/18.
//  Copyright © 2018 Oliver Spalding. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var DirectOneText: String = ""
    var DirectOneTime: String = ""
    var DirectTwoText: String = ""
    var DirectTwoTime: String = ""
   
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//Set Home & Work User Defaults
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        
        if (UserDefaults.standard.value(forKey: "Home") as? String) == nil &&
            (UserDefaults.standard.value(forKey: "Work") as? String == nil){
            //show the onboarding screen
            vc = storyboard.instantiateViewController(withIdentifier: "OnboardingScreenViewController")
        }
        else {
            //show the main screen
            vc = storyboard.instantiateInitialViewController()!
        }
        
// Background App Refresh Config
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

//
        //New Notification Framework
        
        //Manage notifications through UN User Center
        let center = UNUserNotificationCenter.current()
        
        //Set up the request to push notifiacitons 
        let options: UNAuthorizationOptions = [.alert, .sound];
        
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }

        if UserDefaults.standard.value(forKey: "DepartureTime") as? Date != nil {

//Set up content of push notificaiton
        let content = UNMutableNotificationContent()
        content.title = "Traffic Notification"
        content.body = "DirectOneText + DirectOneTime + DirectTwoText + DirectTwoTime"
        content.sound = UNNotificationSound.default()

//Set up both morning and afternoon notifications
        let dateMorning = UserDefaults.standard.value(forKey: "DepartureTime") as! Date
        let dateAfternoon = UserDefaults.standard.value(forKey: "AfternoonTime") as! Date
        let triggerMorning = Calendar.current.dateComponents([.hour, .minute, .second], from: dateMorning)
        let triggerAfternoon = Calendar.current.dateComponents([.hour, .minute, .second], from: dateAfternoon)
        let triggerM = UNCalendarNotificationTrigger(dateMatching: triggerMorning, repeats: true)
        let triggerA = UNCalendarNotificationTrigger(dateMatching: triggerAfternoon, repeats: true)
            
            
        let identifier = "UYLLocalNotification"
        let requestM = UNNotificationRequest(identifier: identifier, content: content, trigger: triggerM)
        let requestA = UNNotificationRequest(identifier: identifier, content: content, trigger: triggerA)
  
            
            center.add(requestM, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
            
            center.add(requestA, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                }
            })
        }
        
        
        //End Framework
        
        //OLD FRAMEWORK:
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
//
//        // PUSH NOTIFICATIONS Check if launched from notification
//        let notificationOption = launchOptions?[.remoteNotification]
//
//        // 1
//        if (notificationOption as? [String: AnyObject]) != nil {
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//        }
//
//       registerForPushNotifications()
        
        
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
        ){}
       
    return true
        
    }

    func application(_ application: UIApplication,
            performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
    //   Get Result Label

    if (UserDefaults.standard.value(forKey: "Home") as? String) != nil &&
    (UserDefaults.standard.value(forKey: "Work") as? String != nil){
    
    (DirectOneText,DirectOneTime,DirectTwoText,DirectTwoTime) = ((window?.rootViewController as? ViewController)?.RunAPI(orgin: "301 Salem St", destination: "501 Salem St"))!
        
    }
        completionHandler(.newData)
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
        
    //OLD: Sends alert to register for push notifications
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current()
//            .requestAuthorization(options: [.alert, .sound, .badge]) {
//                [weak self] granted, error in
//
//                print("Permission granted: \(granted)")
//                guard granted else { return }
//                self?.getNotificationSettings()
//        }

//    }
    //OLD: Figuring out whether push notifications are enabled
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//
//        }
//    }
    
    //OLD:Registering for device tolkens/auth

    //    func application(
//        _ application: UIApplication,
//        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//        ) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
    
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }


}


