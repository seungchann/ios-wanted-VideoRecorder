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
        case failedReadJson
        case failedFetchMedia
    }
    
    static let shared = MediaFileManager()
    private let fm = FileManager.default
    private init() { }
    
    public var numberOfVideos: Int {
        get {
            do {
                return try! fetchJson().count
            }
        }
    }
    
    func pretty(_ data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
    
    func storeMediaInfo(video: Video) {
        // create url
        guard let (dirUrl, fileUrl) = createUrl() else {
            return
        }
        
        // json file check
        guard let data = try? Data(contentsOf: fileUrl) else {
            do {
                try fm.createDirectory(at: dirUrl, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
            putJson(url: fileUrl, originData: nil, newModel: video)
            return
        }
        
        putJson(url: fileUrl, originData: data, newModel: video)
    }
    
//    func fetchJson() -> [Video] {
//        guard let (_, fileUrl) = createUrl() else { return [] }
//        guard let data = try? Data(contentsOf: fileUrl) else { return [] }
//
//        do {
//            let decoder = JSONDecoder()
//            let jsonArray = try decoder.decode([Video].self, from: data)
//            return jsonArray
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
    
    func fetchJson() -> [VideoListItemViewModel] {
        guard let (_, fileUrl) = createUrl() else { return [] }
        guard let data = try? Data(contentsOf: fileUrl) else { return [] }
        var videoListItemViewModels = [VideoListItemViewModel]()
        do {
            let decoder = JSONDecoder()
            let jsonArray = try decoder.decode([Video].self, from: data)
            for video in jsonArray {
                videoListItemViewModels.append(VideoListItemViewModel(video: video))
            }
            return videoListItemViewModels
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func putJson(url fileUrl: URL, originData old: Data?, newModel new: Video) {
        let emptyJson = try! JSONEncoder().encode([Video]())
        do {
            let decoder = JSONDecoder()
            let jsonArray = try decoder.decode([Video].self, from: old ?? emptyJson)
            var json = jsonArray
                json.append(new)
            let data = try! JSONEncoder().encode(json)
            try data.write(to: fileUrl, options: [.atomic])
            NotificationCenter.default.post(name: Notification.Name("mediaInfo_updated"), object: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// unused method
    func renameMedia(oldName: String, newName: String) -> URL? {
        guard let (dirUrl, _) = createUrl() else { return nil }
        let newUrl = dirUrl.appendingPathComponent("\(newName).mp4")
        let oldUrl = dirUrl.appendingPathComponent("\(oldName).mp4")
        do {
            try FileManager.default.moveItem(atPath: oldUrl.relativePath, toPath: newUrl.relativePath)
            return newUrl
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// local video & json  전부 삭제
    func deleteMedia(_ id: String) {
        guard let (dirUrl, fileUrl) = createUrl() else { return }
        guard let data = try? Data(contentsOf: fileUrl) else { return }
        
        do {
            let jsonArray = try JSONDecoder().decode([Video].self, from: data)
            let editedJsonArry = jsonArray.filter { $0.id != id }
            let data = try! JSONEncoder().encode(editedJsonArry)
            try data.write(to: fileUrl, options: [.completeFileProtection])
            let videoUrl = dirUrl.appendingPathComponent(id, conformingTo: .mpeg4Movie)
            try fm.removeItem(at: videoUrl)
        } catch {
            print(error.localizedDescription)
        }
    }

    /// dirUrl 영상 저장 URL,  fileUrl json 저장 URL
    func createUrl() -> (URL, URL)? {
        if let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirUrl = url.appendingPathComponent("VideoRecorder")
            var fileUrl = dirUrl
            do {
                try fm.createDirectory(at: dirUrl, withIntermediateDirectories: true)
                fileUrl.appendPathComponent("Video")
                fileUrl = fileUrl.appendingPathExtension("json")
            } catch {
                print(error.localizedDescription)
            }
            return (dirUrl, fileUrl)
        } else {
            print("No return url.")
            return nil
        }
    }
}
