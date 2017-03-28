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
    
    var rows: [Int] {
        return (0..<100).map { $0 }
    }
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    fileprivate var imagePickerTrayController: ImagePickerTrayController?

    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Images", style: .plain, target: self, action: #selector(toggleImagePickerTray(_:)))
        
        let cellClass = UITableViewCell.self
        tableView.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(willShowImagePickerTray(notification:)), name: ImagePickerTrayWillShow, object: nil)
        center.addObserver(self, selector: #selector(willHideImagePickerTray(notification:)), name: ImagePickerTrayWillHide, object: nil)
    }
    
    // MARK: -
    
    @objc fileprivate func toggleImagePickerTray(_: UIBarButtonItem) {
        if imagePickerTrayController != nil {
            hideImagePickerTray()
        }
        else {
            showImagePickerTray()
        }
    }
    
    fileprivate func showImagePickerTray() {
        let controller = ImagePickerTrayController()
        controller.add(action: .cameraAction { _ in
            print("Show Camera")
        })
        controller.add(action: .libraryAction { _ in
            print("Show Library")
        })
        controller.show(in: view)
        imagePickerTrayController = controller
    }
    
    fileprivate func hideImagePickerTray() {
        imagePickerTrayController?.hide()
        imagePickerTrayController = nil
    }
    
    @objc fileprivate func willShowImagePickerTray(notification: Notification) {
        guard let userInfo = notification.userInfo,
                 let frame = userInfo[ImagePickerTrayFrameUserInfoKey] as? CGRect else {
            return
        }
        
        let duration: TimeInterval = (userInfo[ImagePickerTrayAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
        animateContentInset(inset: frame.height, duration: duration, curve: UIViewAnimationCurve(rawValue: 0)!)
    }
    
    @objc fileprivate func willHideImagePickerTray(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let duration: TimeInterval = (userInfo[ImagePickerTrayAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
        animateContentInset(inset: 0, duration: duration, curve: UIViewAnimationCurve(rawValue: 0)!)
    }
    
    fileprivate func animateContentInset(inset bottomInset: CGFloat, duration: TimeInterval, curve: UIViewAnimationCurve) {
        var inset = tableView.contentInset
        inset.bottom = bottomInset
        
        var offset = tableView.contentOffset
        offset.y = max(0, offset.y - bottomInset)
        
        let options = UIViewAnimationOptions(rawValue: UInt(curve.rawValue) << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.tableView.contentInset = inset
            self.tableView.contentOffset = offset
            self.tableView.scrollIndicatorInsets = inset
        }, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = String(rows[indexPath.row])
        
        return cell
    }
    
}
