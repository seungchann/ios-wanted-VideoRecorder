//
//  VideoListViewCell.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

class VideoListViewCell: UITableViewCell {
    static let identifier = "videoListViewCell"
    lazy var cellContentView = VideoListViewCellContentView()
    
    var viewModel: VideoListItemViewModel? {
        didSet {
            guard let viewModel else { return }
            cellContentView.didReceiveViewModel(viewModel)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func fill(viewModel: VideoListItemViewModel) {
        self.viewModel = viewModel
        self.selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoListViewCell {
    func setupViews() {
        let views = [cellContentView]
        views.forEach { self.contentView.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
