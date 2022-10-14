//
//  FirstRowView.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/14.
//

import UIKit

class FirstRowView: UIView {
    
    // Properties
    let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        // MARK: - Test
        view.backgroundColor = .blue
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

extension FirstRowView {
    func setupViews() {
        let views = [thumbnailView]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor, multiplier: 0.7),
            thumbnailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            thumbnailView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
