//
//  VideoListItemViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

class VideoListItemViewModel {
    var title: Observable<String>
    var duration: Observable<String>
    var releaseDate: Observable<Date>
    var thumbnailImagePath: Observable<String?>
    
    init(video: Video) {
        self.title = Observable(video.title)
        self.duration = Observable(video.duration)
        self.releaseDate = Observable(video.releaseDate)
        self.thumbnailImagePath = Observable(video.thumbnailPath)
    }
}

extension VideoListItemViewModel {
    func getStringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    func getDurationWidthFromString(str: String) -> CGFloat {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 5, weight: .medium)
        label.tintColor = .white
        label.text = str
        
        return label.frame.width
    }
}
