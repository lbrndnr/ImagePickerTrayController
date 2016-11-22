//
//  ViewController.swift
//  Example
//
//  Created by Laurin Brandner on 14.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import ImagePickerTrayController

class ViewController: UIViewController {

    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let button = UIButton(type: .system)
        button.setTitle("Tap Me!", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(presentImagePickerTray(_:)), for: .touchUpInside)
    }
    
    // MARK: - Other Methods
    
    func presentImagePickerTray(_: UITapGestureRecognizer) {
        let controller = ImagePickerTrayController(height: 216)
        present(controller, animated: true, completion: nil)
    }

}

