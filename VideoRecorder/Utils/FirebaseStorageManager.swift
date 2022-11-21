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
    
    let FOLDER_NAME = "Videos"
    let FILE_TYPE = "mp4"
    
    enum StorageError: Error {
        case uploadFailed
    }
    
    struct StorageParameter {
        let id: String
        let url: URL
        
        init(id: String, url: URL) {
            self.id = id
            self.url = url
        }
    }
    
    static let shared = FirebaseStorageManager()
    private let storage: Storage
    
    private init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }
    
//    func upload(_ param: StorageParameter) async throws -> StorageMetadata {
//        let path = "\(FOLDER_NAME)/\(param.id).\(FILE_TYPE)"
//        let storageRef = storage.reference(withPath: path)
//        guard let metadata = try? await storageRef.putFileAsync(from: param.url) else { throw StorageError.uploadFailed }
//        print(metadata)
//        return metadata
//    }
    
    func upload(_ param: StorageParameter) async -> Bool {
        let path = "\(FOLDER_NAME)/\(param.id).\(FILE_TYPE)"
        let storageRef = storage.reference(withPath: path)
        do {
            let metadata = try await storageRef.putFileAsync(from: param.url)
            print(metadata)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func delete(_ id: String) async -> Bool {
        let path = "\(FOLDER_NAME)/\(id).\(FILE_TYPE)"
        let storageRef = storage.reference(withPath: path)
        do {
            print("Sucess Video Delete")
            try await storageRef.delete()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
//    func backup(_ param: StorageParameter, completion: @escaping (Bool) -> Void) {
//        BGTaskManager.shared.beginBackgroundTask(withName: "video_backup") { identifier in
//            Task {
//                print("Video Uploading...")
//                guard let metadata = try? await self.upload(param) else {
//                    identifier.endBackgroundTask()
//                    print("Failed Video Upload")
//                    completion(false)
//                    return
//                }
//                print(metadata)
//                identifier.endBackgroundTask()
//                print("Sucess Video Upload")
//                completion(true)
//            }
//        }
//    }
    
    func backup(_ param: StorageParameter) async -> Bool {
        let identifier = BGTaskManager.shared.beginBackgroundTask(withName: "video_backup")
        let result = await upload(param)
        identifier.endBackgroundTask()
        return result
    }
}
