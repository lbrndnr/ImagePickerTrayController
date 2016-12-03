//
//  CameraViewController.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 03.12.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let session = AVCaptureSession()
    
    fileprivate var cameraView: CameraView {
        return view as! CameraView
    }
    
    fileprivate var devicePosition: AVCaptureDevicePosition = .back {
        didSet {
            reloadCameraDevice()
        }
    }
    
    // MARK: - View Lifecycle

    override func loadView() {
        let layer = AVCaptureVideoPreviewLayer(session: session)!
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        let cameraView = CameraView(previewView: CameraPreviewView(previewLayer: layer))
        cameraView.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        cameraView.flipCameraButton.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)
        
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadCameraDevice()
    }
    
    // MARK: - Camera
    
    fileprivate func reloadCameraDevice() {
        if let oldInput = session.inputs.first as? AVCaptureInput {
            session.removeInput(oldInput)
        }
        
        let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: devicePosition)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        }
        catch {
            
        }
    }
    
    @objc fileprivate func flipCamera() {
        let newPosition: AVCaptureDevicePosition = (devicePosition == .back) ? .front : .back
        
        if isViewLoaded {
            UIView.transition(with: cameraView.previewView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
//                self.devicePosition = newPosition
            }, completion: nil)
        }
        else {
            devicePosition = newPosition
        }
    }
    
    @objc fileprivate func takePicture() {
//        cameraController.takePicture()
    }
    
}
