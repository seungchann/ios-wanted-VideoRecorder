//
//  ViewController.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

import UIKit

class VideoListViewController: UIViewController {
    var viewModel: VideoListViewModel
    
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
    
    init(viewModel: VideoListViewModel) {
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
        bind()
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
        videoListView.register(VideoListViewLoadingCell.self, forCellReuseIdentifier: VideoListViewLoadingCell.identifier)
        cameraButton.addTarget(nil, action: #selector(showRecordVC), for: .touchUpInside)
    }
    
    func bind() {
        viewModel.propateDidSelectDeleteActionEvent = { [weak self] in
            DispatchQueue.main.async {
                self?.updateItems()
            }
        }
        
        viewModel.propagateDidReceiveLoadActionEvent = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self?.updateItems()
                self?.viewModel.isPaging = false
            }
        }
    }
}

extension VideoListViewController {
    func updateItems() {
        videoListView.reloadData()
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.items.count
        } else if section == 1 && viewModel.isPaging && viewModel.isScrollAvailable() {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListViewCell.identifier, for: indexPath) as? VideoListViewCell else {
                return UITableViewCell()
            }
            
            cell.fill(viewModel: self.viewModel.items[indexPath.row])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoListViewLoadingCell.identifier, for: indexPath) as? VideoListViewLoadingCell else {
                return UITableViewCell()
            }
            
            cell.cellContentView.activityIndicatorView.startAnimating()
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, UIView, completion: @escaping (Bool) -> Void) in
            guard let self = self else { return }
            self.viewModel.didSelectDeleteAction(indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoListItemVM = self.viewModel.items[indexPath.row]
        let video = Video(id: videoListItemVM.id.value, title: videoListItemVM.title.value, releaseDate: videoListItemVM.releaseDate.value, duration: videoListItemVM.duration.value, thumbnailPath: videoListItemVM.thumbnailImagePath.value ?? "")
        let playVC = PlayViewController(viewModel: PlayVideoItemViewModel(video: video))
        self.navigationController?.pushViewController(playVC, animated: true)
    }
}

extension VideoListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if !self.viewModel.isPaging && self.viewModel.isScrollAvailable() && !self.viewModel.isEmptyTotalVideoItems() {
                self.viewModel.didReceiveLoadAction()
            }
        }
    }
}

extension VideoListViewController {
    @objc func showRecordVC() {
        let vc = RecordViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}
