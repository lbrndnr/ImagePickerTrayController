//
//  CameraCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 15.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCell: UICollectionViewCell {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    fileprivate func initialize() {
        backgroundColor = .green
        
        let session = AVCaptureSession()
        let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            if let previewLayer = previewLayer {
                previewLayer.frame = bounds
                layer.addSublayer(previewLayer)
            }
        }
        catch {
            
        }
        
//        session.startRunning()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewLayer?.frame = bounds
    }
    
}
