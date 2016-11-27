//
//  CameraOverlayView.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 26.11.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit

class CameraOverlayView: UIButton {
    
    let flipCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(bundledName: "CameraOverlayView-CameraFlip"), for: .normal)
        
        return button
    }()
    
    fileprivate let shutterButtonView = ShutterButtonView()
    
    override var isHighlighted: Bool {
        didSet {
            shutterButtonView.isHighlighted = isHighlighted
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
        addSubview(flipCameraButton)
        addSubview(shutterButtonView)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flipCameraButtonSize = CGSize(width: 44, height: 44)
        let flipCameraButtonOrigin = CGPoint(x: bounds.maxX - flipCameraButtonSize.width, y: bounds.minY)
        flipCameraButton.frame = CGRect(origin: flipCameraButtonOrigin, size: flipCameraButtonSize)
    }
    
}

fileprivate class ShutterButtonView: UIView {
    
    let bezelLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        
        return layer
    }()
    
    let knobLayer: CALayer = {
        let layer = CALayer()
        
        
        return layer
    }()
    
    var isHighlighted = false {
        didSet {
            knobLayer.backgroundColor = (isHighlighted) ? UIColor.lightGray.cgColor : UIColor.white.cgColor
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
        layer.addSublayer(bezelLayer)
        layer.addSublayer(knobLayer)
    }
    
    // MARK: - Layout
    
    fileprivate override func layoutSubviews() {
        bezelLayer.frame = bounds
        
    }
    
}
