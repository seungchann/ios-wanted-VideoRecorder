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
    let captureSession = AVCaptureSession()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureSession.sessionPreset = .high
        
//        guard let videoDevice = AVCaptureDevice.default(.camera, for: .video, position: .back) else {
//            print("not found Capture Device")
//            return
//        }
        
        let videoDevice = bestDevice(in: .back)
        
        do {
            captureSession.beginConfiguration() // 1

            // 2
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }

            // 3
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }

            // 4
            let videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }

            captureSession.commitConfiguration() // 5
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        previewLayer.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.backgroundColor = UIColor.gray.cgColor
        self.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        var deviceTypes: [AVCaptureDevice.DeviceType]!

        if #available(iOS 11.1, *) {
            deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        } else {
            deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
        }

        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )

        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}

        return devices.first(where: { device in device.position == position })!
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

