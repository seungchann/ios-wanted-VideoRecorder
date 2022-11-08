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
    
    enum MediaFileManagerError: Error {
        case NotFoundURL
        case FailedEncoding
    }
    
    enum PathOption: String {
        case document
        case root = "VideoRecorder"
        case videos = "VideoRecorder/Videos"
        case videosInfo
    }
    
    static let shared = MediaFileManager()
    private let fileManager: FileManager
    
    private init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func prettyPrint(videos: [Video]) {
        let data = try! JSONEncoder().encode(videos)
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        }
    }
    
    func createUrl(path: PathOption) -> URL? {
        if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                var url = url
                
                switch path {
                case .document:
                    break
                case .root: // VideoRecorder
                    url = url.appendingPathComponent(path.rawValue)
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
                    break
                    
                case .videos: // VideoRecorder/Videos
                    url = url.appendingPathComponent(path.rawValue)
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
                    break
                    
                case .videosInfo: // VideoRecorder/Videos/Videos.json
                    url = url.appendingPathComponent(PathOption.videos.rawValue)
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
                    url = url.appendingPathComponent("Videos")
                    url = url.appendingPathExtension("json")
                    break
                    
                }
                return url
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            print("Can not create url")
            return nil
        }
    }
    
    func addDummy(url outputUrl: URL) -> URL? {
        guard let docUrl = createUrl(path: .document) else { return nil }
        let dummyUrl = docUrl.appendingPathComponent("sampleVideo.mp4")
        do {
            try fileManager.copyItem(atPath: dummyUrl.relativePath, toPath: outputUrl.relativePath)
            return outputUrl
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getVideos() throws -> [VideoListItemViewModel] {
        guard let url = createUrl(path: .videosInfo) else {
            throw MediaFileManagerError.NotFoundURL
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Not found json")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let videos = try decoder.decode([Video].self, from: data)
            var videoListItemViewModels = [VideoListItemViewModel]()
            
            prettyPrint(videos: videos)
            for video in videos {
                videoListItemViewModels.append(VideoListItemViewModel(video: video))
            }
            return videoListItemViewModels
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getVideosInfo() throws -> [Video] {
        guard let url = createUrl(path: .videosInfo) else {
            throw MediaFileManagerError.NotFoundURL
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Not found json")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let videos = try decoder.decode([Video].self, from: data)
            return videos
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addVideo(video: Video) -> Bool {
        guard let url = createUrl(path: .videosInfo) else { return false }
        
        do {
            var videos = try getVideosInfo()
            videos.append(video)
            let data = try! JSONEncoder().encode(videos)
            try data.write(to: url, options: [.atomic])
            
            prettyPrint(videos: [video])
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    func deleteVideo(id: String) -> Bool {
        guard let videosUrl = createUrl(path: .videos) else { return false }
        guard let jsonUrl = createUrl(path: .videosInfo) else { return false }
        
        let videoUrl = videosUrl.appendingPathComponent(id, conformingTo: .mpeg4Movie)
        do {
            var videos = try getVideosInfo()
            // json에서 해당 video정보 제거
            let data = try JSONEncoder().encode(videos.filter({ $0.id != id }))
            try data.write(to: jsonUrl, options: [.atomic])
            
            prettyPrint(videos: videos.filter { $0.id == id })
            // 현재 저장된 데이터에서 해당 id가 삭제됬는지 확인 후 로컬 영상 제거
            videos = try getVideosInfo()
            if videos.filter({ $0.id == id }).count == 0 {
                try fileManager.removeItem(at: videoUrl)
                return !fileManager.fileExists(atPath: videoUrl.relativePath)
            } else {
                print("Not deleted data about \(id).mp4")
                return false
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
