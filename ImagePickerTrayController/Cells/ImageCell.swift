//
//  ImageCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 15.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    enum ImageCellAccessoryType {
        case video
        case none
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate let shadowView = UIImageView(image: UIImage(bundledName: "ImageCell-Shadow"))
    
    fileprivate let videoIndicatorView: UIImageView = {
        let imageView = UIImageView(image: UIImage(bundledName: "ImageCell-Video"))
        imageView.isHidden = true
        
        return imageView
    }()
    
    fileprivate let checkmarkView: UIImageView = {
        let imageView  = UIImageView(image: UIImage(bundledName: "ImageCell-Selected"))
        imageView.isHidden = true
        
        return imageView
    }()
    
    var accessoryType: ImageCellAccessoryType = .none {
        didSet {
            reloadAccessoryType()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkmarkView.isHidden = !isSelected
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
        contentView.addSubview(imageView)
        contentView.addSubview(shadowView)
        contentView.addSubview(videoIndicatorView)
        contentView.addSubview(checkmarkView)
        reloadAccessoryType()
    }
    
    // MARK: - Other Methods
    
    fileprivate func reloadAccessoryType() {
        switch accessoryType {
        case .video:
            shadowView.isHidden = false
            videoIndicatorView.isHidden = false
        default:
            shadowView.isHidden = true
            videoIndicatorView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        accessoryType = .none
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        
        let shadowHeight = shadowView.image?.size.height ?? 0
        shadowView.frame = CGRect(origin: CGPoint(x: bounds.minX, y: bounds.maxY-shadowHeight), size: CGSize(width: bounds.width, height: shadowHeight))
        
        let videoIndicatorViewSize = videoIndicatorView.image?.size ?? CGSize()
        let inset: CGFloat = 8
        let videoIndicatorViewOrigin = CGPoint(x: bounds.minX + inset, y: bounds.maxY - inset - videoIndicatorViewSize.height)
        videoIndicatorView.frame = CGRect(origin: videoIndicatorViewOrigin, size: videoIndicatorViewSize)
        
        let checkmarkSize = checkmarkView.frame.size
        checkmarkView.center = CGPoint(x: bounds.maxX-checkmarkSize.width/2-4, y: bounds.maxY-checkmarkSize.height/2-4)
    }
    
}
