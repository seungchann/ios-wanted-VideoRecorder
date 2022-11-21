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
        return self.player ?? AVPlayer()
    }
    
    func makeURL(id: String) -> URL {
        guard let dirUrl = try? MediaFileManager.shared.createUrl(path: .videos) else { return URL(string: "/")! }
        let newUrl = dirUrl.appendingPathComponent("\(id).mp4")
        print(newUrl)
        
        // 로컬 path 로 부터 mp4 영상 player 에 import
        return newUrl
    }
    
    func getStringFromTitle(title: String) -> String {
        return title + ".mp4"
    }
}
