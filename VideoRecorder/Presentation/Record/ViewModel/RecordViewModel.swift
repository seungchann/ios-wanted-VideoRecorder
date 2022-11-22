//
//  RecordViewModel.swift
//  VideoRecorder
//
//  Created by 유영훈 on 2022/10/14.
//

import UIKit
import AVFoundation

class RecordViewModel {
    
    let captureSession = AVCaptureSession()
    var videoOutput: AVCaptureMovieFileOutput!
    
    init() { }
    
    deinit {
//        print("deinit RecordViewModel")
    }
}

extension RecordViewModel {
    
    // TODO: 권한 요청 실패의경우 설정으로 안내하는 플로우가 필요
    func checkAuthorization(_ completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            // setup session
            completion(true)
            return
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }

        case .denied: // The user has previously denied access.
            completion(false)
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            completion(false)
            return
        default:
            fatalError("unknown authorizationStatus")
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
    
    func swapCameraPosition() {
        let position = captureSession.inputs.first?.ports.first?.sourceDevicePosition
        let videoDevice = bestDevice(in: position == .back ? .front : .back)
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            captureSession.beginConfiguration()
            for input in captureSession.inputs {
                captureSession.removeInput(input)
            }
            captureSession.addInput(videoInput)
            captureSession.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
}

