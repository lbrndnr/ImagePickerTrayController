//
//  ImagePickerTrayController.swift
//  ImagePickerTrayController
//
//  Created by Laurin Brandner on 14.10.16.
//  Copyright © 2016 Laurin Brandner. All rights reserved.
//

import UIKit
import Photos

/// The media type an instance of ImagePickerSheetController can display
public enum ImagePickerMediaType {
    case image
    case video
    case imageAndVideo
}

public class ImagePickerTrayController: UIViewController {
    
    fileprivate(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 209.0/255.0, green: 213.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ActionCell.self))
        collectionView.register(CameraCell.self, forCellWithReuseIdentifier: NSStringFromClass(CameraCell.self))
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: NSStringFromClass(ImageCell.self))
        
        return collectionView
    }()
    
    fileprivate var assets = [PHAsset]()
    
    fileprivate lazy var requestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        
        return options
    }()
    
    fileprivate let imageManager = PHCachingImageManager()
    
    /// The media type of the displayed assets
    open let mediaType: ImagePickerMediaType = .imageAndVideo
    
    fileprivate let height: CGFloat
    
    fileprivate let imageSize: CGSize
    
    public fileprivate(set) var actions = [ImagePickerAction]()
    
    fileprivate var sections: [Int] {
        let actionSection = (actions.count > 0) ? 1 : 0
        let cameraSection = (previewLayer == nil) ? 0 : 1
        let assetSection = assets.count
        
        return [actionSection, cameraSection, assetSection]
    }
    
    
    let session = AVCaptureSession()
    
    let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Initialization
    
    public init() {
        self.height = 216
        
        let numberOfRows = (UIDevice.current.userInterfaceIdiom == .pad) ? 3 : 2
        let side = round((self.height-2)/CGFloat(numberOfRows))
        self.imageSize = CGSize(width: side, height: side)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                session.startRunning()
            }
        }
        catch {
            
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAssets()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.stopRunning()
    }
    
    // MARK: - Action
    
    public func add(action: ImagePickerAction) {
        actions.append(action)
    }
    
    // MARK: - Images
    
    fileprivate func prepareAssets() {
        fetchAssets()
    }
    
    fileprivate func fetchAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        switch mediaType {
        case .image:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        case .video:
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        case .imageAndVideo:
            options.predicate = NSPredicate(format: "mediaType = %d OR mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        }
        
        let fetchLimit = 100
        options.fetchLimit = fetchLimit
        
        let result = PHAsset.fetchAssets(with: options)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        
        result.enumerateObjects(options: [], using: { asset, index, stop in
            defer {
                if self.assets.count >= fetchLimit {
                    stop.initialize(to: true)
                }
            }
            
            self.imageManager.requestImageData(for: asset, options: requestOptions) { data, _, _, info in
                if data != nil {
                    self.assets.append(asset)
                }
            }
        })
    }
    
    fileprivate func requestImageForAsset(_ asset: PHAsset, completion: @escaping (_ image: UIImage?) -> ()) {
        requestOptions.isSynchronous = true
        
        // Workaround because PHImageManager.requestImageForAsset doesn't work for burst images
        if asset.representsBurst {
            imageManager.requestImageData(for: asset, options: requestOptions) { data, _, _, _ in
                let image = data.flatMap { UIImage(data: $0) }
                completion(image)
            }
        }
        else {
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                completion(image)
            }
        }
    }
    
    fileprivate func prefetchImagesForAsset(_ asset: PHAsset) {
        imageManager.startCachingImages(for: [asset], targetSize: imageSize, contentMode: .aspectFill, options: requestOptions)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ImagePickerTrayController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section]
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ActionCell.self), for: indexPath) as! ActionCell
            cell.actions = actions
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CameraCell.self), for: indexPath) as! CameraCell
            cell.previewLayer = previewLayer
            
            return cell
        case 2:
            let asset = assets[indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ImageCell.self), for: indexPath) as! ImageCell
            requestImageForAsset(asset) { cell.imageView.image = $0 }
            cell.videoIndicatorView.isHidden = (asset.mediaType != .video)
            
            return cell
        default:
            fatalError("More than 3 sections are invalid.")
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagePickerTrayController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 162, height: height)
        case 1:
            return CGSize(width: 150, height: height)
        case 2:
            return imageSize
        default:
            return .zero
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension ImagePickerTrayController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(imagePickerTrayController: self, presenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(imagePickerTrayController: self, presenting: false)
    }
    
}
