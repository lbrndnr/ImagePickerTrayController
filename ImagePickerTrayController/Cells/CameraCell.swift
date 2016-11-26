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
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        willSet {
            previewLayer?.removeFromSuperlayer()
        }
        didSet {
            if let previewLayer = previewLayer {
                contentView.layer.addSublayer(previewLayer)
            }
        }
    }
    
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
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewLayer?.frame = bounds
    }
    
}
