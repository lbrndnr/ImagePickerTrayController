//
//  CameraPreviewView.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 03.12.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    fileprivate let previewLayer: AVCaptureVideoPreviewLayer
    
    // MARK: - Initialization
    
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        super.init(frame: .zero)
        layer.addSublayer(previewLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewLayer.frame = bounds
    }
    
}
