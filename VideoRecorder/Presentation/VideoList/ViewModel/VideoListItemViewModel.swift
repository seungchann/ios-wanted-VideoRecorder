//
//  VideoListItemViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

protocol VideoListItemViewModelProtocol {
    var title: String { get }
    var duration: String { get }
    var releaseDate: String { get }
    var thumbnailImagePath: String? { get }
}

class VideoListItemViewModel: VideoListItemViewModelProtocol {
    var title: String
    var duration: String
    var releaseDate: String
    var thumbnailImagePath: String?
    
    init(video: VideoListItemViewModelProtocol) {
        self.title = video.title
        self.duration = video.duration
        self.releaseDate = video.releaseDate
        self.thumbnailImagePath = video.thumbnailImagePath ?? ""
    }
}
