//
//  ViewController.swift
//  Example
//
//  Created by Laurin Brandner on 14.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import ImagePickerTrayController

class ViewController: UITableViewController {
    
    var rows: [Int] {
        return (0..<100).map { $0 }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Images", style: .plain, target: self, action: #selector(presentImagePickerTray(_:)))
        
        let cellClass = UITableViewCell.self
        tableView.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    // MARK: -
    
    func presentImagePickerTray(_: UITapGestureRecognizer) {
        let controller = ImagePickerTrayController()
        controller.add(action: .cameraAction { _ in
            print("Show Camera")
        })
        controller.add(action: .libraryAction { _ in
            print("Show Library")
        })
        present(controller, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = String(rows[indexPath.row])
        
        return cell
    }
    
}
