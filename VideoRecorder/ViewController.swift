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
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        storage.upload()
    }
    
    @IBAction func fetchButtonPressed(_ sender: Any) {
        storage.fetch { isFetched in
            print(isFetched)
        }
    }
    
    @IBAction func backupButtonPressed(_ sender: Any) {
        storage.backup()
    }
}

