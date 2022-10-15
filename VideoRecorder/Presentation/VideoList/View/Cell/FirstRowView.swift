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
    
    let durationBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        view.layer.cornerRadius = 5
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        return label
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
        let views = [thumbnailView, durationBackgroundView, durationLabel]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor, multiplier: 0.7),
            thumbnailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            thumbnailView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            durationBackgroundView.widthAnchor.constraint(equalTo: durationLabel.widthAnchor, multiplier: 1.2),
            durationBackgroundView.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor, multiplier: 0.25),
            durationBackgroundView.leadingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: 5),
            durationBackgroundView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor.constraint(equalTo: durationBackgroundView.centerYAnchor),
            durationLabel.centerXAnchor.constraint(equalTo: durationBackgroundView.centerXAnchor),
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "backgroundColorAsset")
    }
}

extension UIImageView {
    func masking() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        let path = UIBezierPath(rect: self.bounds)
        let maskingLayer = CAShapeLayer()
        maskingLayer.path = path.cgPath
        self.layer.mask = maskingLayer
    }
}
