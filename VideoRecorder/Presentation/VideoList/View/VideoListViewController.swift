//
//  ViewController.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

struct MockUpVideoViewModel: VideoListViewModelProtocol {
    var items: Observable<[VideoListItemViewModelProtocol]> = Observable([])
}

class VideoListViewController: UIViewController {
    var viewModel: VideoListViewModelProtocol
    
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
    
    var videoListView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: VideoListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        configureView()
    }
}

extension VideoListViewController {
    func setupViews() {
        let views = [menuButton, titleLabel, cameraButton, videoListView]
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
        
        NSLayoutConstraint.activate([
            videoListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            videoListView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 30),
            videoListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    func configureView() {
        videoListView.delegate = self
        videoListView.dataSource = self
        videoListView.register(VideoListViewCell.self, forCellReuseIdentifier: VideoListViewCell.identifier)
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListViewCell.identifier, for: indexPath) as? VideoListViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
