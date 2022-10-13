//
//  PlayViewController.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/13.
//

import UIKit

class PlayViewController: UIViewController {
    var viewModel: VideoListItemViewModel
    
    // Properties
    
    init(viewModel: VideoListItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        configureView()
        bind()
    }
}

extension PlayViewController {
    func setupViews() {
       
    }
    
    func setupConstraints() {
        
    }
    
    func configureView() {
        setNavigationbar()
    }
    
    func bind() {
        self.viewModel.title.subscribe { [weak self] titleString in
            self?.navigationItem.title = titleString
        }
    }
}

extension PlayViewController {
    func setNavigationbar() {
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
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
}
