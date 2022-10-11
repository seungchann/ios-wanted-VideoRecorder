//
//  VideoListViewCell.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

struct MockUpVideoItems: VideoListItemViewModelProtocol {
    var title: String = "Test"
    
    var duration: String = "1:00"
    
    var releaseDate: String = "2022.10.11"
    
    var thumbnailImagePath: String? = ""
}

class VideoListViewCell: UITableViewCell {
    static let identifier = "videoListViewCell"
    private var viewModel: VideoListItemViewModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // 테스트용
        let videos: VideoListItemViewModelProtocol = MockUpVideoItems()
        self.viewModel = VideoListItemViewModel(video: videos)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        self.backgroundColor = .blue
//        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoListViewCell {
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
}
