//
//  AnimationController.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 15.04.17.
//  Copyright © 2017 Laurin Brandner. All rights reserved.
//

import Foundation

class AnimationController: NSObject {
    
    enum Transition {
        case presentation(UIPanGestureRecognizer)
        case dismissal
    }
    
    fileprivate let transition: Transition
    
    init(transition: Transition) {
        self.transition = transition
        super.init()
    }
    
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transition {
        case .presentation(let gestureRecognizer):
            present(with: gestureRecognizer, using: transitionContext)
        case .dismissal:
            dismiss(using: transitionContext)
        }
    }
    
    private func present(with gestureRecognizer: UIPanGestureRecognizer, using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
        container.window?.addGestureRecognizer(gestureRecognizer)
        
        container.addSubview(to.view)
        container.frame = CGRect(x: 0, y: container.bounds.height-216, width: container.bounds.width, height: 216)
        to.view.frame = container.bounds
        
        transitionContext.completeTransition(true)
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to),
            let from = transitionContext.viewController(forKey: .from) as? ImagePickerTrayController else {
                transitionContext.completeTransition(false)
                return
        }
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: { 
            from.view.transform = CGAffineTransform(translationX: 0, y: from.trayHeight)
        }, completion: { finished in
            from.view.removeFromSuperview()
//            to.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
