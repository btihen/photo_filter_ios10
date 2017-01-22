//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var sliderValue: Int?

    var filteredImage: UIImage?
    var originalImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imagePressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet var sliderMenu: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greyButton: UIButton!
    @IBOutlet weak var bwButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // on app load - create an original image
        originalImage = UIImage( named: "scenery" )!
        // load original image into display
        imageView.image = originalImage
        // on app load - disable compare button since there is no filtered image yet
        compareButton.enabled = false
    }
    
    @IBAction func onCompare(sender: UIButton) {
        if compareButton.selected {
            let toImage = filteredImage
            UIView.transitionWithView(self.imageView,
                                      duration:1,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.imageView.image = toImage },
                                      completion: nil)
            imageView.image = filteredImage
            compareButton.selected = false
        } else {
            // http://stackoverflow.com/questions/7638831/fade-dissolve-when-changing-uiimageviews-image
            let toImage = originalImage
            UIView.transitionWithView(self.imageView,
                                      duration:1,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.imageView.image = toImage },
                                      completion: nil)
            imageView.image = originalImage
            compareButton.selected = true
            
        }
    }
    
    // trick is to make sure the image view can see gestures!
    @IBAction func onImagePress(sender: AnyObject) {
        //print("Long tap")
        if sender.state == .Ended {
            //print("touches ended view")
            if filteredImage == nil {
                imageView.image = originalImage
            } else {
                let toImage = filteredImage
                UIView.transitionWithView(self.imageView,
                                          duration:1,
                                          options: UIViewAnimationOptions.TransitionCrossDissolve,
                                          animations: { self.imageView.image = toImage },
                                          completion: nil)
                imageView.image = filteredImage
            }
        }
        else if sender.state == .Began {
            // print("touches began view")
            let toImage = originalImage
            UIView.transitionWithView(self.imageView,
                                      duration:1,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.imageView.image = toImage },
                                      completion: nil)

            imageView.image = originalImage
        }
    }
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        super.touchesBegan(touches, withEvent: event)
    //        print("touches began view")
    //        imageView.image = originalImage
    //    }
    //
    //    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        super.touchesEnded(touches, withEvent: event)
    //        print("touches ended view")
    //        if filteredImage == nil {
    //            imageView.image = originalImage
    //        } else {
    //            imageView.image = filteredImage
    //        }
    //    }
    
    
    @IBAction func onSlider(sender: UISlider) {
        // print("on slider")
        // print( sliderValue )
        sliderValue = Int(sender.value)
        // sliderValue = roundUp(Int(sender.value), divisor: 1000)
        if redButton.selected == true {
            filteredImage = RedFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if greenButton.selected == false {
            filteredImage = GreenFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if blueButton.selected == false {
            filteredImage = GreenFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if greyButton.selected == false {
        }
        if bwButton.selected == false {
        }
        imageView.image = filteredImage
    }
   
    @IBAction func onRedFilter(sender: UIButton) {
        if redButton.selected {
            redButton.selected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.enabled = false
            hideSliderMenu()
        } else {
            redButton.selected    = true
            greenButton.selected  = false
            blueButton.selected   = false
            greyButton.selected   = false
            bwButton.selected     = false
            compareButton.enabled = true
            filteredImage = RedFilter(percentage: 50).filter( originalImage! )
            showSliderMenu()
            // filteredImage = RedFilter(percentage: sliderValue!).filter( originalImage! )
            imageView.image = filteredImage
        }
    }

    @IBAction func onGreenFilter(sender: UIButton) {
        if greenButton.selected {
            greenButton.selected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.enabled = false
        } else {
            redButton.selected    = false
            greenButton.selected  = true
            blueButton.selected   = false
            greyButton.selected   = false
            bwButton.selected     = false
            compareButton.enabled = true
            filteredImage = GreenFilter(percentage: 50).filter( originalImage! )
            imageView.image = filteredImage
        }
    }
    
    @IBAction func onBlueFilter(sender: UIButton) {
        if blueButton.selected {
            blueButton.selected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.enabled = false
        } else {
            redButton.selected    = false
            greenButton.selected  = false
            blueButton.selected   = true
            greyButton.selected   = false
            bwButton.selected     = false
            compareButton.enabled = true
            filteredImage = BlueFilter(percentage: 50).filter( originalImage! )
            imageView.image = filteredImage
        }
    }
    
    @IBAction func onGreyFilter(sender: UIButton) {
    }
    
    @IBAction func onBWFilter(sender: UIButton) {
    }
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImage = newImage
            imageView.image = newImage
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }

    func showSliderMenu() {
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(secondaryMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderMenu.alpha = 1.0
        }
    }
    
    func hideSliderMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

