//
//  ViewController.swift
//  VideoRecorder
//
//  Created by kjs on 2022/10/07.
//

import UIKit
import FirebaseStorage
import Photos
import AVFoundation

class ViewController: UIViewController {

    let storage = FirebaseStorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func upload(_ sender: Any) {
        Task {
            guard let metadata = try? await self.storage.upload() else { return }
            print(metadata)
        }
    }
    
    @IBAction func fetch(_ sender: Any) {
        storage.fetch { isFetched in
            print(isFetched)
        }
    }
    
    @IBAction func uploadInBG(_ sender: Any) {
        storage.uploadInBG()
    }
    
    @IBAction func fetchInBG(_ sender: Any) {
        storage.fetchInBG()
    }
    
    @IBAction func backup(_ sender: Any) {
        storage.backup()
    }
    
    @IBAction func remain(_ sender: Any) {
        
    }
}

