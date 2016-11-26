//
//  ActionCell.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 22.11.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import Foundation

let spacing = CGPoint(x: 26, y: 14)
private let stackViewOffset: CGFloat = 102

class ActionCell: UICollectionViewCell {
    
    fileprivate let stackContainerView = UIView()

    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = spacing.x/2
        
        return stackView
    }()

    fileprivate let chevronImageView: UIImageView = {
        let bundle = Bundle(for: ImagePickerTrayController.self)
        let image = UIImage(named: "ActionCell-Chevron", in: bundle, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.alpha = 0.5

        return imageView
    }()

    var actions = [ImagePickerAction]() {
        // It is sufficient to compare the length of the array
        // as actions can only be added but not removed
        
        willSet {
            if newValue.count != actions.count {
                stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            }
        }
        didSet {
            if stackView.arrangedSubviews.count != actions.count {
                actions.map { ActionButton(action: $0, target: self, selector: #selector(callAction(sender:))) }
                       .forEach { stackView.addArrangedSubview($0) }
            }
        }
    }
    
    var disclosureProcess: CGFloat = 0 {
        didSet {
            let progress = max(disclosureProcess, 0)
            chevronImageView.alpha = progress/2
            chevronImageView.transform = CGAffineTransform(translationX: (1-progress) * spacing.x, y: 0)
            stackView.transform = CGAffineTransform(translationX: (1-progress) * stackViewOffset, y: 0)
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
        contentView.addSubview(stackContainerView)
        stackContainerView.addSubview(stackView)
        contentView.addSubview(chevronImageView)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = bounds.insetBy(dx: spacing.x, dy: spacing.y)
        chevronImageView.center = CGPoint(x: bounds.maxX - spacing.x/2, y: bounds.midY)
    }
    
    // MARK: - 
    
    @objc fileprivate func callAction(sender: UIButton) {
        if let index = stackView.arrangedSubviews.index(of: sender) {
            actions[index].call()
        }
    }

}

fileprivate class ActionButton: UIButton {
    
    // MARK: - Initialization
    
    init(action: ImagePickerAction, target: Any, selector: Selector) {
        super.init(frame: .zero)
        
        setTitle(action.title, for: .normal)
        setTitleColor(.black, for: .normal)
        setImage(action.image.withRenderingMode(.alwaysTemplate), for: .normal)
        
        imageView?.tintColor = .black
        imageView?.contentMode = .bottom
        
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 14)
        
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 11.0
        addTarget(target, action: selector, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    fileprivate override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.divided(atDistance: contentRect.midX, from: .minYEdge).slice
    }
    
    fileprivate override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.divided(atDistance: contentRect.midX, from: .minYEdge).remainder
    }
    
}
