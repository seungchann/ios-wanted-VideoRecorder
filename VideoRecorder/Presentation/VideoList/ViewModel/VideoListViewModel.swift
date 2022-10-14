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
    
    // Output
    var items: [VideoListItemViewModel]
    var propateDidSelectDeleteActionEvent: () -> () = { }
    
    init(videoItems: [VideoListItemViewModel]) {
        self.items = videoItems
        bind()
    }
    
    private func bind() {
        didSelectDeleteAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            let item = self.items[indexPathRow]
            self.removeData(item: item)
            self.propateDidSelectDeleteActionEvent()
        }
    }
}

extension VideoListViewModel {
    func removeData(item video : VideoListItemViewModel) {
        Task {
            // 로컬부터 파일삭제
        }
        self.items = self.items.filter { $0.title.value != video.title.value }
    }
}
