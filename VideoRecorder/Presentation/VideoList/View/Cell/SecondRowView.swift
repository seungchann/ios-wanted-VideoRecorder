//
//  SecondRowView.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/14.
//

import UIKit

class SecondRowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .yellow
//        setupViews()
//        setupConstraints()
        configureView()
//        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondRowView {
    func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
