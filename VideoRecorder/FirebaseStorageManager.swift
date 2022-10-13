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
    let storage = Storage.storage()
    private init() { }
    
    func upload(_ param: [String:Any]) async throws -> StorageMetadata {
        let foldername = "test"
        let filename = "\(param["name"]!).\(param["type"]!)"
        let storageRef = storage.reference(withPath: "\(foldername)/\(filename)")
        let url = param["url"] as! URL
        guard let metadata = try? await storageRef.putFileAsync(from: url) else { throw StorageError.noMetaData }
        return metadata
    }
    
//    func fetch(_ completion: @escaping (Bool) -> Void){
//        let storageRef = storage.reference(withPath: "test/")
//
//        let image = UIImage(systemName: "circle")?.pngData()
//
//        storageRef.child("test.png").downloadURL { result in
//            print(result)
//            completion(true)
//        }
//    }
    
//    func delete() {
//        let storageRef = storage.reference(forURL: "")
//    }
    
    func mediaBackup(_ param: [String:Any]) {
        BGTaskManager.shared.beginBackgroundTask(withName: "media_backup") { identifier in
            DispatchQueue.main.async { [weak self] in
                print("Task Resume")
                Task {
                    guard let metadata = try? await self!.upload(param) else {
                        identifier.endBackgroundTask()
                        print("Task Failed But Finish")
                        return
                    }
                    print(metadata)
                    identifier.endBackgroundTask()
                    print("Task Complete")
                }
            }
        }
    }
}
