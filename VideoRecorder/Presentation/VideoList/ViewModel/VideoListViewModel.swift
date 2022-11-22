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
        // TODO: 각 작업이 실패할 경우 처리 구현 필요
        Task {
            if !MediaFileManager.shared.deleteVideo(id: video.id.value) {
                // 로컬 비디오 삭제 실패
            }
            if await !FirebaseStorageManager.shared.delete(video.id.value) {
                // 백업 비디오 삭제 실패
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
