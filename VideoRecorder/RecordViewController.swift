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
        view.adjustsImageWhenHighlighted = false
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
        view.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
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
    var uuid: UUID?
    var recordingTimer: Timer?
    var viewModel: RecordViewModel
       
    init(viewModel: RecordViewModel) {
       self.viewModel = viewModel
       super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let viewModel = RecordViewModel()
        self.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureView()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.viewModel.setupSession()
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.viewModel.setupSession()
                }
            }

        case .denied: // The user has previously denied access.
            return

        case .restricted: // The user can't grant access due to restrictions.
            return
        }
    }
    
    deinit {
        print("deinit")
    }
}

extension RecordViewController {
    func setupViews() {
        previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        previewLayer!.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        previewLayer!.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        previewLayer!.videoGravity = .resizeAspectFill
        previewLayer!.backgroundColor = UIColor.black.cgColor
        self.view.layer.addSublayer(previewLayer!)
        
        let views = [exitButton, controlPannelStack]
        let controls = [etcButton, recordButtonGroup, swapCameraPositionButton]
        let recordButtons = [circleImage, timeLabel]
        views.forEach { self.view.addSubview($0) }
        controls.forEach { controlPannelStack.addArrangedSubview($0) }
        recordButtons.forEach { recordButtonGroup.addArrangedSubview($0) }
        circleImage.addSubview(recordButton)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: circleImage.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalTo: recordButtonGroup.heightAnchor, multiplier: 0.15),
            timeLabel.widthAnchor.constraint(equalTo: recordButtonGroup.widthAnchor),
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
        circleImage.addTarget(nil, action: #selector(startRecording), for: .touchUpInside)
        recordButton.addTarget(nil, action: #selector(startRecording), for: .touchUpInside)
        exitButton.addTarget(nil, action: #selector(goToPrevious), for: .touchUpInside)
        swapCameraPositionButton.addTarget(nil, action: #selector(swapCameraPosition), for: .touchUpInside)
    }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("didFinishRecordingTo", outputFileURL)
        
        let nowDate = Date(timeInterval: 32400, since: Date())
        let duration = String(Int(output.recordedDuration.seconds))
        let position = viewModel.captureSession.inputs.first?.ports.first?.sourceDevicePosition
        
        self.askForTextAndConfirmWithAlert(title: "알림", placeholder: "영상의 제목을 입력해주세요") { [weak self]
            filename in
            guard let self = self else { return }

            let model = Video(id: self.uuid!.uuidString, title: filename!, releaseDate: nowDate, duration: duration, thumbnailPath: outputFileURL.relativePath)
            MediaFileManager.shared.storeMediaInfo(video: model)
            
            let param = FirebaseStorageManager.StorageParameter(id: self.uuid!.uuidString, filename: filename!, url: outputFileURL)
            FirebaseStorageManager.shared.backup(param)
            
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("didStartRecordingTo", fileURL)
    }
}

extension RecordViewController {
    
    @objc func goToPrevious() {
        // to main
        self.dismiss(animated: true)
    }
    
    @objc func swapCameraPosition() {
        viewModel.swapCameraPosition()
    }
    
    @objc func checkRecordingTime() {
        let recordedDuration = Int(viewModel.videoOutput.recordedDuration.seconds)
        let m = recordedDuration / 60
        let s = recordedDuration % 60
        let duration = String(format: "%02d:%02d", arguments: [m, s])
        self.timeLabel.text = duration
    }
    
    // Recording Methods
    @objc func startRecording() {
        
        if viewModel.videoOutput.isRecording {
            stopRecording()
            return
        }
        swapCameraPositionButton.isEnabled = false
        
        recordingTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(checkRecordingTime), userInfo: nil, repeats: true)
        
        UIView.transition(with: self.timeLabel, duration: 0.25, options: [.transitionCrossDissolve, .transitionCurlUp]) {
            self.timeLabel.alpha = 1.0
            self.timeLabel.isHidden = false
            self.timeLabel.transform = CGAffineTransform(translationX: 0, y: -15)
            self.recordButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        
        guard let (dirUrl, _) = MediaFileManager.shared.createUrl() else {
            return
        }
        
        uuid = UUID()
        let saveUrl = dirUrl.appendingPathComponent("\(uuid!.uuidString).mp4")
        viewModel.videoOutput.startRecording(to: saveUrl, recordingDelegate: self)
    }
    
    @objc private func stopRecording() {
        if viewModel.videoOutput.isRecording {
            viewModel.videoOutput.stopRecording()
            UIView.transition(with: self.timeLabel, duration: 0.25, options: [.transitionCrossDissolve, .transitionCurlUp]) {
                self.timeLabel.alpha = 0
                self.timeLabel.isHidden = true
                self.timeLabel.transform = CGAffineTransform(translationX: 0, y: 15)
                self.recordButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            swapCameraPositionButton.isEnabled = true
        }
    }
}
