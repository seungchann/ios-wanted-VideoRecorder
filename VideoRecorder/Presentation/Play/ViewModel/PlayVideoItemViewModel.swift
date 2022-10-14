//
//  PlayVideoItemViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/13.
//

import UIKit
import AVKit

class PlayVideoItemViewModel {
    var id: Observable<String>
    var title: Observable<String>
    var thumbnailImagePath: Observable<String?>
    var player: AVPlayer?
    
    init(video: Video) {
        self.id = Observable(video.id)
        self.title = Observable(video.title)
        self.thumbnailImagePath = Observable(video.thumbnailPath)
    }
}

extension PlayVideoItemViewModel {
    func loadVideo() -> AVPlayer {
        self.player = AVPlayer(url: makeURL(id: self.id.value))
        // MARK: - 실제 URL 연결 필요
//        self.player = AVPlayer(url: makeURL(path: self.thumbnailImagePath.value ?? ""))
        return self.player ?? AVPlayer()
    }
    
    func makeURL(id: String) -> URL {
        guard let (dirUrl, _) = MediaFileManager.shared.createUrl() else {
            return URL(string: "")!
        }

        let newUrl = dirUrl.appendingPathComponent("\(id).mp4")
        
        print(newUrl)
        print("!!!!!")
        print(URL(string: "file://" + (self.thumbnailImagePath.value ?? ""))!)
        // 로컬 path 로 부터 mp4 영상 player 에 import
        return newUrl
    }
}

// MARK: - For Test
extension PlayVideoItemViewModel {
    func makeTestURL() -> URL {
        // 비디오 저장될 디렉토리 URL
        guard let (dirUrl, _) = MediaFileManager.shared.createUrl() else {
            return URL(string: "")!
        }
        // File 이름 추가
        let newName = "test1"
        let newUrl = dirUrl.appendingPathComponent("\(newName).mp4")
        // using url
        return newUrl
    }
}
