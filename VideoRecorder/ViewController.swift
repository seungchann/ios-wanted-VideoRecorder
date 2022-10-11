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

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("didFinishRecordingTo", outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("didStartRecordingTo", fileURL)
    }

    let storage = FirebaseStorageManager.shared
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput!
    
    let recordButton: UIButton = {
        let view = UIButton()
        view.setTitle("녹화", for: .normal)
        view.backgroundColor = .red
        return view
    }()
    
    let stopButton: UIButton = {
        let view = UIButton()
        view.setTitle("중지", for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.testCapture()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.testCapture()
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
        
        
    }
    
    func testCapture() {
        captureSession.sessionPreset = .high
        
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
            videoOutput = AVCaptureMovieFileOutput()
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
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(stopButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        recordButton.addTarget(nil, action: #selector(start), for: .touchUpInside)
        stopButton.addTarget(nil, action: #selector(stop), for: .touchUpInside)
        
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    @objc func start() {
        startRecording()
    }
    
    @objc func stop() {
        stopRecording()
    }
    
    // Recording Methods
    private func startRecording() {
//        let outputURL = URL(string: "")   // 파일이 저장될 경로
        guard let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let dirUrl = docsUrl.appendingPathComponent("videos")
        
        var isDir: ObjCBool = true
        if !FileManager.default.fileExists(atPath: "\(dirUrl)", isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let saveUrl = dirUrl.appendingPathComponent("MyFileSaveName.mp4")
        
        videoOutput.startRecording(to: saveUrl, recordingDelegate: self)
    }
      
    private func stopRecording() {
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        }
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

