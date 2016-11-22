//
//  ActionCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 22.11.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import Foundation

private let spacing = CGPoint(x: 26, y: 14)

class ActionCell: UICollectionViewCell {
    
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = spacing.x/2
        
        return stackView
    }()
    
    var actions = [ImagePickerAction]() {
        willSet {
            stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        }
        didSet {
            actions.map { action -> UIButton in
                let button = UIButton()
                button.setTitle(action.title, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.setImage(action.image.withRenderingMode(.alwaysTemplate), for: .normal)
                button.imageView?.tintColor = .black
                button.backgroundColor = .white
                button.layer.masksToBounds = true
                button.layer.cornerRadius = 11.0
                button.addTarget(self, action: #selector(callAction(sender:)), for: .touchUpInside)
                
                return button
            }.forEach { stackView.addArrangedSubview($0) }
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
        addSubview(stackView)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = bounds.insetBy(dx: spacing.x, dy: spacing.y)
    }
    
    // MARK: - 
    
    @objc fileprivate func callAction(sender: UIButton) {
        if let index = stackView.arrangedSubviews.index(of: sender) {
            actions[index].call()
        }
    }

}
