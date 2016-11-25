//
//  ImageCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 15.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let videoIndicatorView: UIImageView = {
        let imageView = UIImageView(image: UIImage(bundledName: "ImageCell-Video"))
        imageView.isHidden = true
        
        return imageView
    }()
    
    fileprivate let checkmarkView: UIImageView = {
        let imageView  = UIImageView(image: UIImage(bundledName: "ImageCell-Selected"))
        imageView.isHidden = true
        
        return imageView
    }()
    
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
        contentView.addSubview(videoIndicatorView)
        contentView.addSubview(checkmarkView)
    }
    
    // MARK: - Other Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        videoIndicatorView.isHidden = true
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        
        let videoIndicatorViewSize = videoIndicatorView.image?.size ?? CGSize()
        let inset: CGFloat = 8
        let videoIndicatorViewOrigin = CGPoint(x: bounds.minX + inset, y: bounds.maxY - inset - videoIndicatorViewSize.height)
        videoIndicatorView.frame = CGRect(origin: videoIndicatorViewOrigin, size: videoIndicatorViewSize)
        
        let checkmarkSize = checkmarkView.frame.size
        checkmarkView.center = CGPoint(x: bounds.maxX-checkmarkSize.width/2-4, y: bounds.maxY-checkmarkSize.height/2-4)
    }
    
}
