//
//  AnimationController.swift
//  ImagePickerSheet
//
//  Created by Laurin Brandner on 25/05/15.
//  Copyright (c) 2015 Laurin Brandner. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    
    let imagePickerTrayController: ImagePickerTrayController
    let presenting: Bool
    
    // MARK: - Initialization
    
    init(imagePickerTrayController: ImagePickerTrayController, presenting: Bool) {
        self.imagePickerTrayController = imagePickerTrayController
        self.presenting = presenting
    }
    
    // MARK: - Animation
    
    fileprivate func animatePresentation(_ context: UIViewControllerContextTransitioning) {
        let containerView = context.containerView
        containerView.addSubview(imagePickerTrayController.view)
        
        let sheetOriginY = imagePickerTrayController.view.frame.origin.y
        imagePickerTrayController.view.frame.origin.y = containerView.bounds.maxY
        
        UIView.animate(withDuration: transitionDuration(using: context), delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.imagePickerTrayController.view.frame.origin.y = sheetOriginY
        }, completion: { _ in
            context.completeTransition(true)
        })
    }
    
    fileprivate func animateDismissal(_ context: UIViewControllerContextTransitioning) {
        let containerView = context.containerView
        
        UIView.animate(withDuration: transitionDuration(using: context), delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.imagePickerTrayController.view.frame.origin.y = containerView.bounds.maxY
        }, completion: { _ in
            self.imagePickerTrayController.view.removeFromSuperview()
            context.completeTransition(true)
        })
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension AnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresentation(transitionContext)
        }
        else {
            animateDismissal(transitionContext)
        }
    }
    
}
