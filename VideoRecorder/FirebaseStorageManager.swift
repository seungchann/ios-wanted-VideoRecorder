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
    
    struct StorageParameter {
        let id: String
        let filename: String
        let url: URL
        
        init(id: String, filename: String, url: URL) {
            self.id = id
            self.filename = filename
            self.url = url
        }
    }
    
    static let shared = FirebaseStorageManager()
    let storage = Storage.storage()
    let FOLDER_NAME = "test" //"Videos"
    let FILE_TYPE = "mp4"
    
    private init() { }
    
    func upload(_ param: StorageParameter) async throws -> StorageMetadata {
        let path = "\(FOLDER_NAME)/\(param.id).\(FILE_TYPE)"
        let storageRef = storage.reference(withPath: path)
        guard let metadata = try? await storageRef.putFileAsync(from: param.url) else { throw StorageError.noMetaData }
        return metadata
    }
    
    func delete(_ id: String) async -> Bool {
        let path = "\(FOLDER_NAME)/\(id).\(FILE_TYPE)"
        let storageRef = storage.reference(withPath: path)
        let result = try? await storageRef.delete()
        return result != nil
    }
    
    func backup(_ param: StorageParameter) {
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
    
    //    private func fetch(_ completion: @escaping (Bool) -> Void){
    //        let storageRef = storage.reference(withPath: "test/")
    //
    //        let image = UIImage(systemName: "circle")?.pngData()
    //
    //        storageRef.child("test.png").downloadURL { result in
    //            print(result)
    //            completion(true)
    //        }
    //    }
}
