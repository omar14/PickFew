//
//  ShareViewController.swift
//  Pick
//
//  Created by Omar Al-Essa on 10/21/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import LocalAuthentication
import AVKit
import AVFoundation

class ShareViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    
    //MARK: - UIOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var exitIcon: UIImageView!
    
    //MARK: - Constraints
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    
    
    //MARK: - Variables
    var playerViewController = AVPlayerViewController()
    var mediaArray = [AnyObject]()
    var content: NSExtensionItem?
    var numberOfPic: Int?
    var zoomedImage = UIImage()
    var typeOfMedia = [Int: Int]()
    var imageForCell = [Int: UIImage]()
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        Crashlytics().debugMode = true
//        Fabric.with([Crashlytics.self])
    }
    
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = (extensionContext!.inputItems[0] as! NSExtensionItem)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        numberOfPic = (content?.attachments?.count)!
        
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
        
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height { // Landscape
            exitBtn.isHidden = true
            exitIcon.isHidden = true
            collectionViewBottomConstraint.constant = 0
        } else { // Portain
            exitBtn.isHidden = false
            exitIcon.isHidden = false
            collectionViewBottomConstraint.constant = 46
        }
        
    }
    
    
    //MARK: - UICollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfPic!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let picCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickCellId", for: indexPath) as! PickCell
        
        picCell.contentView.frame = picCell.bounds
        
        scrollView.setZoomScale(1, animated: false)
        
        let index = (indexPath as NSIndexPath).section
        let movieContentType = kUTTypeMovie as String
        let imageContentType = kUTTypeImage as String
        
        let attachment = content!.attachments![index] as! NSItemProvider
        
        if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
            
            attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { data, error in
                if error == nil {
                    let url = data as! URL
                    if let imageData = try? Data(contentsOf: url) {
                        OperationQueue.main.addOperation({
                            picCell.pickImage.image = UIImage(data: imageData)
                            picCell.playVideoImg.isHidden = true
                            picCell.pickImage.isHidden = false
                            
                            self.typeOfMedia[indexPath.section] = 1
                            self.imageForCell[indexPath.section] = picCell.pickImage.image
                            
                        })
                    }
                }
            }
        }
        else if attachment.hasItemConformingToTypeIdentifier(movieContentType) {
            
            attachment.loadItem(forTypeIdentifier: movieContentType, options: nil) { data, error in
                if error == nil {
                    if let url = data as? URL {
                        OperationQueue.main.addOperation({
                            picCell.pickImage.image = self.thumbnailForVideoAtURL(url)
                            self.playerViewController.player = AVPlayer(url: url)
                            picCell.playVideoImg.isHidden = false
                            
                            self.typeOfMedia[indexPath.section] = 2
                            
                        })
                    }
                }
            }
        }
        
        
        return picCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if typeOfMedia[indexPath.section] == 1 {
            myImageView.image = imageForCell[indexPath.section]
            scrollView.isHidden = false
        }
        else {
            self.present(playerViewController, animated: true, completion: {
                self.playerViewController.player?.play()
            })
        }
        
        
    }
    
    
    
    //MARK: - Play Video Click
    func playVideo(_ sender: UITapGestureRecognizer) {
        
        self.present(playerViewController, animated: true, completion: {
            self.playerViewController.player?.play()
        })
        
    }
    
    
    
    //MARK: - Exit Click
    @IBAction func click(_ sender: UIButton) {
        authenticateUser()
    }
    
    func authenticateUser() {
        
        let context = LAContext()
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { [weak self] (success, error) in
            
            guard success else {
                DispatchQueue.main.async {
                    // show something here to block the user from continuing
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self!.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        
    }
    
    
    //MARK: - Get Thumbnail for video
    fileprivate func thumbnailForVideoAtURL(_ url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            
            if (image.imageOrientation == UIImageOrientation.up) {
                print("portrait")
            } else if (image.imageOrientation == UIImageOrientation.left || image.imageOrientation == UIImageOrientation.right) {
                print("landscape")
            }
            
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    
    //MARK: - Exit Zoom
    @IBAction func exitZoom(_ sender: UITapGestureRecognizer) {
        
        self.myImageView.image = nil
        scrollView.isHidden = true
    }
    
    
    //MARK: - UIScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
    
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        self.myImageView.image = nil
    }
    
    
}
