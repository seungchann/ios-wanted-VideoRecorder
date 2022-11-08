//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import Foundation

class VideoListViewModel {
    // Input
    var didSelectDeleteAction: (Int) -> () = { indexPathRow in }
    var didReceiveLoadAction: () -> () = { }
    
    // Output
    var totalItems: [VideoListItemViewModel]
    var items: [VideoListItemViewModel]
    var propateDidSelectDeleteActionEvent: () -> () = { }
    var propagateDidReceiveLoadActionEvent: () -> () = { }
    
    // Properties
    var isPaging: Bool
    var currentIndex: Int
    
    init(videoItems: [VideoListItemViewModel]) {
        self.isPaging = false
        self.totalItems = videoItems
        self.currentIndex = min(6, self.totalItems.count-1)
        self.items = !self.totalItems.isEmpty ? Array<VideoListItemViewModel>(self.totalItems[0...currentIndex]) : Array<VideoListItemViewModel>()
        bind()
    }
    
    private func bind() {
        didSelectDeleteAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            let item = self.items[indexPathRow]
            self.removeData(item: item, index: indexPathRow)
            self.propateDidSelectDeleteActionEvent()
        }
        
        didReceiveLoadAction = { [weak self] in
            guard let self = self else { return }
            self.isPaging = true
            self.currentIndex = min(self.currentIndex + 6, self.totalItems.count-1)
            self.items = !self.totalItems.isEmpty ? Array<VideoListItemViewModel>(self.totalItems[0...self.currentIndex]) : Array<VideoListItemViewModel>()
            self.propagateDidReceiveLoadActionEvent()
        }
    }
}

extension VideoListViewModel {
    func removeData(item video : VideoListItemViewModel, index: Int) {
        Task {
            // MARK: - 로컬부터 파일삭제
            if await FirebaseStorageManager.shared.delete(video.id.value) {
                if !MediaFileManager.shared.deleteVideo(id: video.id.value) {
                    // failed delete video
                    // but 보이는 리스트에서는 일시적으로 삭제됨.
                }
            }
        }
        self.items.remove(at: index)
    }
    
    func isScrollAvailable() -> Bool {
        return !(self.totalItems.count-1 == self.currentIndex)
    }
    
    func isEmptyTotalVideoItems() -> Bool {
        return self.totalItems.isEmpty
    }
}
