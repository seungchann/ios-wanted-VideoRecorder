//
//  PlayViewController.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/13.
//

import UIKit
import AVKit

class PlayViewController: AVPlayerViewController {
    var viewModel: PlayVideoItemViewModel
    
    init(viewModel: PlayVideoItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.DefaultTheme.mainBackground
        self.player = self.viewModel.loadVideo()
        self.player?.play()
        configureView()
        bind()
    }
}

extension PlayViewController {
    func configureView() {
        setupNavigationbar()
    }
    
    func bind() {
        self.viewModel.title.subscribe { [weak self] title in
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.viewModel.getStringFromTitle(title: title)
            }
        }
    }
}

extension PlayViewController {
    func setupNavigationbar() {
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 15, *) {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = .white
            barAppearance.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
            ]
            self.navigationItem.standardAppearance = barAppearance
            self.navigationItem.scrollEdgeAppearance = barAppearance
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
            ]
        }
        self.navigationController?.navigationBar.tintColor = UIColor.DefaultTheme.mainForeground
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
}
