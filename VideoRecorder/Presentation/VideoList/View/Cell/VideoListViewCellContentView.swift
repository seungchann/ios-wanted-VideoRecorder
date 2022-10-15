//
//  VideoListViewCellContentView.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/14.
//

import UIKit

class VideoListViewCellContentView: UIView {

    // Input
    var didReceiveViewModel: (VideoListItemViewModel) -> () = { viewModel in  }
    
    // Properties
    var firstRowView = FirstRowView()
    var secondRowView = SecondRowView()
    
    var viewModel: VideoListItemViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VideoListViewCellContentView {
    func setupViews() {
        let views = [firstRowView, secondRowView]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            firstRowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            firstRowView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            firstRowView.topAnchor.constraint(equalTo: self.topAnchor),
            firstRowView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            secondRowView.leadingAnchor.constraint(equalTo: firstRowView.trailingAnchor),
            secondRowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            secondRowView.topAnchor.constraint(equalTo: self.topAnchor),
            secondRowView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bind() {
        didReceiveViewModel = { [weak self] viewModel in
            guard let self = self else { return }
            self.viewModel = viewModel
            
            viewModel.id.subscribe { [weak self] id in
                ThumbnailMaker.shared.generateThumnailAsync(filename: id, startOffsets: [1, 10]) { [weak self] thumbnailImage in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.firstRowView.thumbnailView.image = thumbnailImage
                        self.firstRowView.thumbnailView.masking()
                    }
                }
            }
            
            viewModel.title.subscribe { [weak self] title in
                guard let self = self else { return }
                self.secondRowView.titleLabel.text = viewModel.getStringFromTitle(title: title)
            }
            
            viewModel.releaseDate.subscribe { [weak self] date in
                guard let self = self else { return }
                self.secondRowView.releaseDateLabel.text = viewModel.getStringFromDate(date: date)
            }
            
            viewModel.duration.subscribe { [weak self] duration in
                guard let self = self else { return }
                self.firstRowView.durationLabel.text = viewModel.getStringFromDuration(duration: duration)
            }
        }
    }
}
