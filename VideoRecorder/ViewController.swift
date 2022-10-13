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
            self.setupSession()
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupSession()
                }
            }
            
        case .denied: // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            return
        }
    }
    
    func setupView() {
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
    
    func setupSession() {
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
            setupView()
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
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
        
        guard let (dirUrl, _) = MediaFileManager.shared.createUrl() else {
            return
        }
        let saveUrl = dirUrl.appendingPathComponent("\(UUID()).mp4")
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
}

extension ViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("didFinishRecordingTo", outputFileURL)
        
        let nowDate = Date(timeInterval: 32400, since: Date())
        let duration = String(Int(output.recordedDuration.seconds))
        
        self.askForTextAndConfirmWithAlert(title: "알림", placeholder: "영상의 제목을 입력해주세요") { filename in
            
            if let newUrl = MediaFileManager.shared.renameMedia(originURL: outputFileURL, newName: filename!) {
                let filetype = "mp4"
                do {
                    let model = Video(title: filename!, releaseDate: nowDate, duration: duration, thumbnailPath: newUrl.absoluteString)
                    try? MediaFileManager.shared.storeMediaInfo(infoModel: model)
                } catch {
                    print(error.localizedDescription)
                }
                
                //                ThumbnailMaker.shared.generateThumnailAsync(url: url!, startOffsets: [1,10]) { image in
                //                    DispatchQueue.main.async {
                //                        let imageView = UIImageView()
                //                        imageView.image = image
                //                        imageView.translatesAutoresizingMaskIntoConstraints = false
                //
                //                        self.view.addSubview(imageView)
                //                        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                //                        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                //                        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                //                        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                //                    }
                //                }
                
                FirebaseStorageManager.shared.mediaBackup([
                    "name": "\(filename!)_\(nowDate.debugDescription)",
                    "type": filetype,
                    "url": newUrl
                ])
            }
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("didStartRecordingTo", fileURL)
    }
}
