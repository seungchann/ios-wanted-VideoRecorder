//
//  FirebaseStorageManager.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/11.
//

import Foundation
import FirebaseStorage
import BackgroundTasks

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    
    private init() { }
    
    func upload() {
        let foldername = "test"
        let filename = "test.png"
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "\(foldername)/\(filename)")
        let image = UIImage(systemName: "circle")?.pngData()
        
        storageRef.putData(image!) { data in
            print(data)
        }.resume()
    }
    
    func fetch(_ completion: @escaping (Bool) -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "test/")
        
        let image = UIImage(systemName: "circle")?.pngData()
        
        storageRef.child("test.png").downloadURL { result in
            print(result)
            completion(true)
        }
    }
    
    func backup() {
        
        let scheduler = BGTaskScheduler.shared
        let request = BGProcessingTaskRequest(identifier: "yh.backup")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 1)
            request.requiresExternalPower = true
            request.requiresNetworkConnectivity = true
        do {
            try scheduler.submit(request)
        } catch(let error) {
            print(error)
        }
    }
}
