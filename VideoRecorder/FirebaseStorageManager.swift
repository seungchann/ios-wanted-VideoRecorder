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
    
    enum StorageError: Error {
        case noMetaData
    }
    
    static let shared = FirebaseStorageManager()
    
    private init() { }
    
    func upload(_ completion: @escaping (Bool) -> Void) {
        let foldername = "test"
        let filename = "test.png"
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "\(foldername)/\(filename)")
        let image = UIImage(systemName: "circle")?.pngData()
        
        storageRef.putData(image!) { result in
            switch result {
            case .success(let metadata):
                print(metadata)
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }.resume()
    }
    
    func upload() async throws -> StorageMetadata {
        let foldername = "test"
        let filename = "test.png"
        let storage = Storage.storage()
        let storageRef = storage.reference(withPath: "\(foldername)/\(filename)")
        let image = UIImage(systemName: "circle")?.pngData()
        guard let metadata = try? await storageRef.putDataAsync(image!) else { throw StorageError.noMetaData }
        return metadata
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
    
    func uploadInBG() {
        let scheduler = BGTaskScheduler.shared
        let request = BGProcessingTaskRequest(identifier: "upload")
            request.requiresNetworkConnectivity = true

        do {
            try scheduler.submit(request)
        } catch(let error) {
            print(error)
        }
    }
    
    func fetchInBG() {
        let scheduler = BGTaskScheduler.shared
        let request = BGProcessingTaskRequest(identifier: "fetch")
            request.requiresNetworkConnectivity = true

        do {
            try scheduler.submit(request)
        } catch(let error) {
            print(error)
        }
    }
    
    func backup() {
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
//            print("Task Resume")
//            Task {
//                guard let metadata = try? await self.upload() else { return }
//                print(metadata)
//                print("Task Complete")
//            }
//        }
        
        BGTaskManager.shared.beginBackgroundTask(withName: "media_backup") { identifier in
            DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
                print("Task Resume")
                Task {
                    guard let metadata = try? await self.upload() else { return }
                    print(metadata)
//                    identifier.endBackgroundTask()
                    print("Task Complete")
                }
            }
        }
    }
}
