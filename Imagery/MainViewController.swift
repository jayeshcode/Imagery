//
//  MainViewController.swift
//  Imagery
//
//  Created by Jayesh Wadhwani on 2016-06-14.
//  Copyright © 2016  Jayesh Wadhwani. All rights reserved.
//

import UIKit
import ALCameraViewController
import CoreData

class MainViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, EVCDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var greyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var greyView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
  
    
    @IBOutlet var myView: UIView!
    let kHeightShort: CGFloat = 0
    let kHeightLong: CGFloat = 50
    var stretched = false
    var deleteisSelected = false
    var images: Array<UIImage> = []
   
    var selectedIndexes=[]

    @IBOutlet weak var socialView: UIView!
    
    // when View Loads
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.setImage(UIImage(named: "lens.png"), forState: UIControlState.Normal)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        greyViewHeight.constant=kHeightShort
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing=20
        self.collectionView.collectionViewLayout = layout
        self.collectionView.allowsMultipleSelection = true
        
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        selectedIndexes = collectionView.indexPathsForSelectedItems()!
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  // Camera Buttons Clicked
    @IBAction func actionOnCAmera(sender: AnyObject) {
        let croppingEnabled = false
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: false) { image in
            if let img = image.0 {
                self.images.append(img)
            }
            self.dismissViewControllerAnimated(true, completion: { self.collectionView.reloadData() })
        }
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    
     //delegate method image picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        images.append(image)
        self.collectionView!.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    
    
    // Add button Clicked
    @IBAction func actionOnADD(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        
        greyViewHeight.constant =  kHeightShort
        self.cameraButton.hidden = false
        self.animate()

    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.imagePicked.image = self.images[indexPath.item]
        if cell.selected {
            cell.layer.borderWidth = 4.0
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        } else {
            cell.layer.borderWidth = 0.0
        }
        print((collectionView.indexPathsForSelectedItems()?.count)! as Int)
        print(selectedIndexes.count)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexes=collectionView.indexPathsForSelectedItems()!
        self.cameraButton.hidden = selectedIndexes.count > 0
        self.editButton.enabled = selectedIndexes.count <= 1
        self.shareButton.enabled = selectedIndexes.count <= 1
        greyViewHeight.constant = selectedIndexes.count > 0 ? kHeightLong : kHeightShort
        self.animate()
        
        
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
            
        cell?.layer.borderWidth = 4.0
        cell?.layer.borderColor = UIColor.grayColor().CGColor
        greyViewHeight.constant=kHeightLong
        self.animate()
    }
    
    
    // Cell Did DESelect
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.layer.borderWidth = 0.0
        selectedIndexes = collectionView.indexPathsForSelectedItems()!
        greyViewHeight.constant = selectedIndexes.count > 0 ? kHeightLong : kHeightShort
        self.animate()
        self.editButton.enabled = selectedIndexes.count <= 1
        self.shareButton.enabled = selectedIndexes.count <= 1
        self.cameraButton.hidden = selectedIndexes.count > 0
    }
    
    
    //configure cell
    
    
    /*
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Share Button clicked
   
    
    @IBAction func actionOnShare(sender: AnyObject) {
        

        
        
        if collectionView.indexPathsForSelectedItems()?.count <= 1
        {
            // Create the alert controller
            let alertController = UIAlertController(title: "Social", message: "Choose Your Option", preferredStyle: .Alert)
            
            // Create the actions
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                 self.postOnFacebook()
           
            
            }
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) {
                UIAlertAction in
               self.postOnTwitter()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                //alertController .removeFromParentViewController()
            }

            
            
            // Add the actions
            alertController.addAction(facebookAction)
            alertController.addAction(twitterAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            
        }else
        {
        
            let alertController = UIAlertController(title: "Alert", message:
                "Select a single Image to share", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            

        
        }
   
        
        
        
        }
    
    
    
    // save Button Clicked
    @IBAction func actionOnSave(sender: AnyObject) {
      
        
        if let selectedIndexes = collectionView.indexPathsForSelectedItems() {

           
            
            for idx in selectedIndexes {
                let image = images[idx.item]
                let imageData = UIImageJPEGRepresentation(image, 0.6)
                
                
                let compressedJPGImage = UIImage(data: imageData!)
                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
                
            }
            let alertController = UIAlertController(title: "Hey there", message:
                "\(selectedIndexes.count) images were successfully saved to camera roll.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            greyViewHeight.constant =  kHeightShort
            self.cameraButton.hidden = false
            self.animate()
            
            collectionView.reloadData()

            
        }else{
            

            
            let alertController = UIAlertController(title: "Hey!", message:
                "No images are selected, please select images that you want to save to camera roll.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
  
            
            
            
        }
        
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "editSegue" {
            if selectedIndexes.count > 1 || selectedIndexes.count == 0 {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    // pass the photo to edit view controller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue" {
            let ip = selectedIndexes.lastObject as! NSIndexPath
            let cell = collectionView.cellForItemAtIndexPath(ip) as! CustomCollectionViewCell
            let dvc = segue.destinationViewController as! EditViewController
            dvc.delegate = self
            dvc.originalPhoto = cell.imagePicked.image
            dvc.indexPath = ip
            collectionView.deselectItemAtIndexPath(ip, animated: false)
            selectedIndexes = collectionView.indexPathsForSelectedItems()!
            greyViewHeight.constant = kHeightShort
            collectionView.reloadData()
            cameraButton.hidden = true
        }
    }
    
    // Delete Button Clicked
    @IBAction func actionOnDelete(sender: AnyObject) {
        
        if sender is UIButton {
            
        
        

        if  collectionView.indexPathsForSelectedItems()!.count > 0
        {
        
            let idxsToRemove = collectionView.indexPathsForSelectedItems()!.map({ $0.item })
            images = images.enumerate().filter({ !idxsToRemove.contains($0.0) }).map({ $0.1 })
            
            
            greyViewHeight.constant =  kHeightShort
            self.cameraButton.hidden = false
            self.animate()

            collectionView.reloadData()
            
        }else{
            
            
            let alertController = UIAlertController(title: "Hey!", message:
                "No images are selected, please select images that you want to delete.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    }


    func   animate(){
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 15, options: [], animations: {
            
            self.myView.layoutIfNeeded()
            
            
        }) {
            _ in
            
            
            
            
        }
        
        
        
    }
    
    // MARK: EVCDelegate
    func updateCollectionView(image: UIImage, indexPath: NSIndexPath) {
        images.removeAtIndex(indexPath.item)
        images.insert(image, atIndex: indexPath.item)
        collectionView.reloadData()
    }
    
    func showCamera() {
        cameraButton.hidden = false
    }
    
    //MARK: Actions
    
    @IBAction func cancelPressed(sender: UIButton) {
        collectionView.reloadData()
        greyViewHeight.constant = kHeightShort
        cameraButton.hidden = false
    }
}










