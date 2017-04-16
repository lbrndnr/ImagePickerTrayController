//
//  InteractiveDismissal.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 16.04.17.
//  Copyright © 2017 Laurin Brandner. All rights reserved.
//

import Foundation

class InteractiveDismissal: UIPercentDrivenInteractiveTransition {
    
    fileprivate(set) var hasBeenRecognized = false
    
    fileprivate weak var trayController: ImagePickerTrayController?
    let gestureRecognizer = UIPanGestureRecognizer()
    
    init(trayController: ImagePickerTrayController) {
        self.trayController = trayController
        super.init()
        
        gestureRecognizer.addTarget(self, action: #selector(didRecognizePan(gestureRecognizer:)))
        gestureRecognizer.delegate = self
    }
    
}

extension InteractiveDismissal: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func didRecognizePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let trayController = trayController,
                        let view = gestureRecognizer.view else {
            cancel()
            return
        }
        
        if gestureRecognizer.state == .began {
            gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
        }
        else if gestureRecognizer.state == .changed {
            let end = gestureRecognizer.location(in: gestureRecognizer.view).y
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let start = end - translation.y
            let threshold = view.frame.maxY - trayController.trayHeight
            if hasBeenRecognized {
                let progress = end-threshold
                update(progress/trayController.trayHeight)
            }
            else if start < threshold && end >= threshold {
                hasBeenRecognized = true
                trayController.dismiss(animated: true, completion: nil)
            }
        }
        else if gestureRecognizer.state == .cancelled {
            cancel()
        }
        else if gestureRecognizer.state == .ended {
            finish()
        }
    }
    
}
