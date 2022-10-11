//
//  VideoListViewCell.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

// MARK: - Test
struct MockUpVideoItems: VideoListItemViewModelProtocol {
    var title: String = "Test"
    var duration: String = "1:00"
    var releaseDate: String = "2022.10.11"
    var thumbnailImagePath: String? = ""
}

class VideoListViewCell: UITableViewCell {
    static let identifier = "videoListViewCell"
    private var viewModel: VideoListItemViewModel
    
    let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        // MARK: - Test
        view.backgroundColor = .blue
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - Test
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // MARK: - Test
        label.text = "2022-09-04"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
        
    }()
    
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
//        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoListViewCell {
    func setupViews() {
        let views = [thumbnailView, titleLabel, releaseDateLabel]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            thumbnailView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            thumbnailView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            thumbnailView.widthAnchor.constraint(equalToConstant: 120),
            thumbnailView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailView.trailingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.thumbnailView.centerYAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: self.thumbnailView.centerYAnchor, constant: 10)
        ])
    }
}
