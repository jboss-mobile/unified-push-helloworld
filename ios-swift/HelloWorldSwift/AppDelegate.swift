/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        if let options = launchOptions {
            if let option : NSDictionary = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
                let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
                if let aps : NSDictionary = option["aps"] as? NSDictionary {
                    if let alert : String = aps["alert"] as? String {
                        defaults.setObject(alert, forKey: "message_received")
                        defaults.synchronize()
                    }
                }
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        NSLog("APN Success")
        let registration = AGDeviceRegistration(serverURL: NSURL(string: "<# URL of the running AeroGear UnifiedPush Server #>"))
        
        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!) -> () in
            NSLog("UPS Register")
            clientInfo.deviceToken = deviceToken
            clientInfo.variantID = "<# Variant Id #>"
            clientInfo.variantSecret = "<# Variant Secret #>"
            
                // apply the token, to identify THIS device
                let currentDevice = UIDevice()
            
                // --optional config--
                // set some 'useful' hardware information params
                clientInfo.operatingSystem = currentDevice.systemName
                clientInfo.osVersion = currentDevice.systemVersion
                clientInfo.deviceType = currentDevice.model
            }, success: { () -> () in
                NSLog("UPS Success Register")
                // Send NSNotification for success_registered, will be handle by registered AGViewController
                let notification = NSNotification(name:"success_registered", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
                
            }, failure: { (error:NSError!) -> () in
                NSLog("UPS Error Register")
                let notification = NSNotification(name:"error_registered", object: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            })
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        NSLog("ERROR")
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: NSDictionary!) {
        // When a message is received, send NSNotification, will be handle by registered AGViewController
        let notification:NSNotification = NSNotification(name:"message_received", object:userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        NSLog("UPS message received: %@", userInfo);
    }


}

