//
//  MediaFileManager.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/12.
//

import Foundation

/**
    로컬 미디어, 미디어 정보 JSON 관리
 */
class MediaFileManager {
    
    enum FileManagerError: Error {
        case failedStoreMediaErrors
    }
    
    static let shared = MediaFileManager()
    private init() { }
    private let fm = FileManager.default
    
    func storeMediaInfo(infoModel: Video) throws {
        
        // create url
        guard let (dirUrl, fileUrl) = createUrl() else {
            throw FileManagerError.failedStoreMediaErrors
        }
        
        // json file check
        guard let data = try? Data(contentsOf: fileUrl) else {
            try fm.createDirectory(at: dirUrl, withIntermediateDirectories: true)
            let data = try! JSONEncoder().encode([Video]())
            writeJson(url: fileUrl, originData: data, newModel: infoModel)
            throw FileManagerError.failedStoreMediaErrors
        }
        
        writeJson(url: fileUrl, originData: data, newModel: infoModel)
    }
    
    func writeJson(url fileUrl: URL, originData old: Data, newModel new: Video) {
        do {
            let decoder = JSONDecoder()
            let jsonArray = try decoder.decode([Video].self, from: old)
            var json = jsonArray
                json.append(new)
            let data = try! JSONEncoder().encode(json)
            try data.write(to: fileUrl, options: [.atomic])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func renameMedia(originURL: URL, newName: String) -> URL? {
        guard let (dirUrl, _) = createUrl() else {
            return nil
        }
        let newUrl = dirUrl.appendingPathComponent("\(newName).mp4")
        
        do {
            try FileManager.default.moveItem(atPath: originURL.relativePath, toPath: newUrl.relativePath)
            return newUrl
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func deleteMedia() {
        
    }
    
    func createUrl() -> (URL, URL)? {
        if let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            var dirUrl = url.appendingPathComponent("VideoRecorder")
            var fileUrl = dirUrl
            do {
                try fm.createDirectory(at: dirUrl, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
            fileUrl.appendPathComponent("Video")
            fileUrl = fileUrl.appendingPathExtension("json")
            return (dirUrl, fileUrl)
        } else {
            print("not return URL")
            return nil
        }
    }
}
