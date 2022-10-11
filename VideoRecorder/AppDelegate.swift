//
//  AppDelegate.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import FirebaseCore
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        backgroundTaskRegister()
        
        return true
    }
    
    func backgroundTaskRegister() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "upload", using: .global(qos: .background)) { task in
            print("uploading...")
            self.upload { isUploaded in
                print("uploaded!")
                task.setTaskCompleted(success: isUploaded)
            }
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "fetch", using: .global(qos: .background)) { task in
            print("feching...")
            self.fetch { isFetched in
                print("fetched!")
                task.setTaskCompleted(success: isFetched)
            }
        }
    }
    
    func upload(_ completion: @escaping (Bool) -> Void) {
        FirebaseStorageManager.shared.upload { isUploaded in
            completion(isUploaded)
        }
    }
    
    func fetch(_ completion: @escaping (Bool) -> Void) {
        FirebaseStorageManager.shared.fetch { isFetched in
            completion(isFetched)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

