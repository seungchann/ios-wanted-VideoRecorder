//
//  SecondRowView.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/14.
//

import UIKit

class SecondRowView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "subTextColorAsset")
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let rightArrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .darkGray
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

extension SecondRowView {
    func setupViews() {
        let views = [titleLabel, releaseDateLabel, rightArrowImageView]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -3),
            titleLabel.trailingAnchor.constraint(equalTo: rightArrowImageView.leadingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 3)
        ])
        
        NSLayoutConstraint.activate([
            rightArrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            rightArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightArrowImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.08),
            rightArrowImageView.heightAnchor.constraint(equalTo: rightArrowImageView.widthAnchor, multiplier: 1.3)
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "backgroundColorAsset")
    }
}
