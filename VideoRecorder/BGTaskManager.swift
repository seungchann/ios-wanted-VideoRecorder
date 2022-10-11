//
//  BGTaskManager.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/11.
//

import UIKit
import BackgroundTasks

class BGTaskManager {
    
    static let shared = BGTaskManager()
    private var backgroundTaskIdentifiers = [UIBackgroundTaskIdentifier]()
    private init() { }
    
    func beginBackgroundTask(withName: String? = nil, _ completion: @escaping (UIBackgroundTaskIdentifier) -> Void) {
        var backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: withName) { [weak self] in
            print("END")
            self?.endBackgroundTask(identifier: backgroundTaskIdentifier)
        }
        self.backgroundTaskIdentifiers.append(backgroundTaskIdentifier)
        completion(backgroundTaskIdentifier)
    }
    
    func endAllBackgroundTask() {
       let identifiers = self.backgroundTaskIdentifiers
       self.backgroundTaskIdentifiers.removeAll()
       identifiers.forEach({ UIApplication.shared.endBackgroundTask($0) })
    }

    func endBackgroundTask(identifier: UIBackgroundTaskIdentifier) {
       if let index = self.backgroundTaskIdentifiers.firstIndex(where: { $0 == identifier }) {
           self.backgroundTaskIdentifiers.remove(at: index)
       }
       UIApplication.shared.endBackgroundTask(identifier)
    }
}

extension UIBackgroundTaskIdentifier {
    func endBackgroundTask() {
        BGTaskManager.shared.endBackgroundTask(identifier: self)
    }
}
