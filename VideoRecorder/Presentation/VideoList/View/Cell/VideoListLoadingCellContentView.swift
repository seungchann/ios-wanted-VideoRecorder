//
//  VideoListLoadingCellContentView.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/15.
//

import UIKit

class VideoListLoadingCellContentView: UIView {

    // Properties
    var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VideoListLoadingCellContentView {
    func setupViews() {
        let views = [activityIndicatorView]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
