//
//  VideoListItemViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

struct VideoListItemViewModel {
    var title: Observable<String>
    var duration: Observable<String>
    var releaseDate: Observable<String>
    var thumbnailImagePath: Observable<String?>
    
    init(video: Video) {
        self.title = Observable(video.title)
        self.duration = Observable(video.duration)
        self.releaseDate = Observable(dateFormatter.string(from: video.releaseDate))
        self.thumbnailImagePath = Observable(video.thumbnailPath)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
