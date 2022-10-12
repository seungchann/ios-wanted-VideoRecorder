//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import Foundation

class VideoListViewModel {
    // Input
    
    
    // Output
    var items: [VideoListItemViewModel]
    
    init(videoItems: [VideoListItemViewModel]) {
        self.items = videoItems
    }
}
