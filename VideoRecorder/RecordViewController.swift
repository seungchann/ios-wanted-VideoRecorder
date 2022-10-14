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

class RecordViewController: UIViewController {
    
    let storage = FirebaseStorageManager.shared
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput!
    var recordingTimer: Timer?
    
    let controlPannelStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = .darkGray
        view.alpha = 0.7
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let recordButtonGroup: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let circleImage: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 60)
        view.setImage(UIImage(systemName: "circle", withConfiguration: configuration), for: .normal)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let recordButton: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 35)
        view.setImage(UIImage(systemName: "circle.fill", withConfiguration: configuration), for: .normal)
        view.tintColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeLabel: UILabel = {
        let view = UILabel()
        view.alpha = 0
        view.isHidden = true
        view.transform = CGAffineTransform(translationX: 0, y: 10)
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "00:00"
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let exitButton: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        view.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration), for: .normal)
        view.tintColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let swapCameraPositionButton: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        view.setImage(UIImage(systemName: "camera.rotate", withConfiguration: configuration), for: .normal)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let etcButton: UIButton = {
        let view = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        view.setImage(UIImage(systemName: "square.fill", withConfiguration: configuration), for: .normal)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureView()
        
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
            
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
            
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    @objc func checkRecordingTime() {
        print(videoOutput.recordedDuration)
        let m = 0
        let s = 0
        let duration = "\(m):\(s)"
        self.timeLabel.text = duration
    }
    
    // Recording Methods
    @objc func startRecording() {
        
        UIView.transition(with: self.timeLabel, duration: 0.5, options: [.transitionCrossDissolve, .transitionCurlUp]) {
            self.timeLabel.alpha = 1.0
            self.timeLabel.isHidden = false
            self.timeLabel.transform = CGAffineTransform(translationX: 0, y: -15)
            self.recordButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
//        recordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkRecordingTime), userInfo: nil, repeats: true)
        
        guard let (dirUrl, _) = MediaFileManager.shared.createUrl() else {
            return
        }
        let saveUrl = dirUrl.appendingPathComponent("\(UUID()).mp4")
        videoOutput.startRecording(to: saveUrl, recordingDelegate: self)
    }
    
    @objc private func stopRecording() {
//        recordingTimer?.invalidate()
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

extension RecordViewController {
    func setupViews() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        previewLayer!.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        previewLayer!.videoGravity = .resizeAspectFill
        previewLayer!.backgroundColor = UIColor.lightGray.cgColor
        self.view.layer.addSublayer(previewLayer!)
        
        let views = [exitButton, controlPannelStack]
        let controls = [etcButton, recordButtonGroup, swapCameraPositionButton]
        let recordButtons = [circleImage, timeLabel]
        views.forEach { self.view.addSubview($0) }
        controls.forEach { controlPannelStack.addArrangedSubview($0) }
        recordButtons.forEach { recordButtonGroup.addArrangedSubview($0) }
        circleImage.addSubview(recordButton)
        
        recordButton.addTarget(nil, action: #selector(startRecording), for: .touchUpInside)
        exitButton.addTarget(nil, action: #selector(goToPrevious), for: .touchUpInside)
        swapCameraPositionButton.addTarget(nil, action: #selector(swapCameraPosition), for: .touchUpInside)
    }
    
    @objc func goToPrevious() {
        // to main
    }
    
    @objc func swapCameraPosition() {
        guard let input = captureSession.inputs.first else {
            print("no input")
            return
        }
        let position = input.ports.first!.sourceDevicePosition
        let videoDevice = bestDevice(in: position)
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            captureSession.beginConfiguration()
            if !captureSession.canAddInput(videoInput) {
                captureSession.removeInput(input)
            }
            captureSession.addInput(videoInput)
            captureSession.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: circleImage.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalTo: recordButtonGroup.heightAnchor, multiplier: 0.15),
        ])
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            exitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            controlPannelStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
            controlPannelStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            controlPannelStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            controlPannelStack.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            swapCameraPositionButton.widthAnchor.constraint(equalTo: etcButton.widthAnchor, multiplier: 1.0),
            swapCameraPositionButton.widthAnchor.constraint(equalTo: recordButtonGroup.widthAnchor, multiplier: 0.8),
        ])
    }
    
    func configureView() {
        // delegate or register
    }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("didFinishRecordingTo", outputFileURL)
        
        let nowDate = Date(timeInterval: 32400, since: Date())
        let duration = String(Int(output.recordedDuration.seconds))
        
        self.askForTextAndConfirmWithAlert(title: "알림", placeholder: "영상의 제목을 입력해주세요") { filename in
            
            if let newUrl = MediaFileManager.shared.renameMedia(originURL: outputFileURL, newName: filename!) {
                let filetype = "mp4"
                do {
                    let model = Video(title: "\(filename!)_\(nowDate.debugDescription)", releaseDate: nowDate, duration: duration, thumbnailPath: newUrl.absoluteString)
                    try? MediaFileManager.shared.storeMediaInfo(infoModel: model)
                } catch {
                    print(error.localizedDescription)
                }
                
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
