//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit

class VideoViewController: UIViewController {
    
    // Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Video List"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let menuButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cameraButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "video.fill"), for: .normal)
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
    }
}

extension VideoViewController {
    func setupViews() {
        let views = [menuButton, titleLabel, cameraButton]
        views.forEach { self.view.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            menuButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            menuButton.heightAnchor.constraint(equalToConstant: 20),
            menuButton.widthAnchor.constraint(equalTo: menuButton.heightAnchor, multiplier: 1.2),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.menuButton.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: self.menuButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            cameraButton.centerYAnchor.constraint(equalTo: self.menuButton.centerYAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 20),
            cameraButton.widthAnchor.constraint(equalTo: cameraButton.heightAnchor, multiplier: 1.5),
        ])
    }
}
