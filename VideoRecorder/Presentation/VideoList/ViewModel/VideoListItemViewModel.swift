//
//  VideoListItemViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

class VideoListItemViewModel {
    var id: Observable<String>
    var title: Observable<String>
    var duration: Observable<Int>
    var releaseDate: Observable<Date>
    var thumbnailImagePath: Observable<String?>
    
    init(video: Video) {
        self.id = Observable(video.id)
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
    
    func getStringFromDuration(duration: Int) -> String {
        if duration < 60 {
            return "00:" + String(duration)
        } else if duration < 3600 {
            let min = String(Int(Double(duration/60)))
            var sec = String(duration%60)
            // 0 ~ 9초 일 경우
            sec = (sec.count == 1) ? ("0" + sec) : sec
            return "\(min):\(sec)"
        } else {
            let hour = String(Int(Double(duration/3600)))
            let remaining = duration%3600
            var min = String(Int(Double(remaining/60)))
            min = (min.count == 1) ? ("0"+min) : min
            var sec = String(remaining%60)
            sec = (sec.count == 1) ? ("0"+sec) : sec
            return "\(hour):\(min):\(sec)"
        }
    }
    
    func getStringFromTitle(title: String) -> String {
        return title + ".mp4"
    }
}
