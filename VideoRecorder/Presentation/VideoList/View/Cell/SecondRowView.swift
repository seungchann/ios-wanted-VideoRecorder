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
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
//        self.backgroundColor = .yellow
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
        let views = [titleLabel, releaseDateLabel]
        views.forEach { self.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            releaseDateLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 5)
        ])
    }
    
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
