//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import Foundation

protocol VideoListViewModelProtocol {
    var items: Observable<[VideoListItemViewModelProtocol]> { get }
}

class VideoListViewModel: VideoListViewModelProtocol {
    // Input
    
    
    // Output
    var items: Observable<[VideoListItemViewModelProtocol]> = Observable([])
    
    init(videoItems: VideoListViewModelProtocol) {
        self.items = videoItems.items
    }
}
