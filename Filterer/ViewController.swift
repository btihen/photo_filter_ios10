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
    
    @IBOutlet var topLabel: UIView!
    @IBOutlet var sliderMenu: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var lightenButton: UIButton!
    @IBOutlet weak var darkenButton: UIButton!
    @IBOutlet weak var contrastButton: UIButton!
    @IBOutlet weak var greyButton: UIButton!
    @IBOutlet weak var bwButton: UIButton!
    
    @IBOutlet weak var compareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        topLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        topLabel.translatesAutoresizingMaskIntoConstraints=false
        
        // on app load - create an original image
        originalImage = UIImage( named: "scenery" )!
        // load original image into display
        imageView.image = originalImage
        // on app load - disable compare button since there is no filtered image yet
        compareButton.isEnabled = false
    }
    
    
    // http://stackoverflow.com/questions/7638831/fade-dissolve-when-changing-uiimageviews-image
    @IBAction func endCompare(_ sender: UIButton) {
        hideTopLabel()
        let toImage = filteredImage
        UIView.transition(with: self.imageView,
                                  duration:0.5,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.imageView.image = toImage },
                                  completion: nil)
        imageView.image = filteredImage
        compareButton.isSelected = false
    }
    @IBAction func onCompare(_ sender: UIButton) {
        showTopLabel()
        let toImage = originalImage
        UIView.transition(with: self.imageView,
                                  duration:0.5,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.imageView.image = toImage },
                                  completion: nil)
        imageView.image = originalImage
        compareButton.isSelected = true
    }
    // @IBAction func compareToggle(sender: UIButton) {
        //        if compareButton.selected {
        //            let toImage = filteredImage
        //            UIView.transitionWithView(self.imageView,
        //                                      duration:1,
        //                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
        //                                      animations: { self.imageView.image = toImage },
        //                                      completion: nil)
        //            imageView.image = filteredImage
        //            compareButton.selected = false
        //        } else {
        //            let toImage = originalImage
        //            UIView.transitionWithView(self.imageView,
        //                                      duration:1,
        //                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
        //                                      animations: { self.imageView.image = toImage },
        //                                      completion: nil)
        //            imageView.image = originalImage
        //            compareButton.selected = true
        //        }
    // }
    
    // trick is to make sure the image view can see gestures!
    @IBAction func onImagePress(_ sender: AnyObject) {
        // print("Long tap")
        if sender.state == .ended {
            //print("touches ended view")
            if filteredImage == nil {
                imageView.image = originalImage
            } else {
                hideTopLabel()
                let toImage = filteredImage
                UIView.transition(with: self.imageView,
                                          duration:0.5,
                                          options: UIViewAnimationOptions.transitionCrossDissolve,
                                          animations: { self.imageView.image = toImage },
                                          completion: nil)
                imageView.image = filteredImage
            }
        }
        else if sender.state == .began {
            // print("touches began view")
            showTopLabel()
            let toImage = originalImage
            UIView.transition(with: self.imageView,
                                      duration:0.5,
                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                      animations: { self.imageView.image = toImage },
                                      completion: nil)

            imageView.image = originalImage
        }
    }
    // doing touches by hand - just experimenting
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
    
    
    func showTopLabel(){
        view.addSubview(topLabel)
        let heightConstraint = topLabel.heightAnchor.constraint(equalToConstant: 55)
        let leftConstraint   = topLabel.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint  = topLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        let topConstraint = topLabel.topAnchor.constraint(equalTo: view.topAnchor)
        //let bottomConstraint = topLabel.bottomAnchor.constraintEqualToAnchor(imageView.topAnchor)
        NSLayoutConstraint.activate([topConstraint,leftConstraint,rightConstraint,heightConstraint])
        //NSLayoutConstraint.activateConstraints([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
        view.layoutIfNeeded()
        topLabel.alpha=0
        UIView.animate(withDuration: 0.2, animations: {
            self.topLabel.alpha=1.0
        })
    }
    
    func hideTopLabel(){
        UIView.animate(withDuration: 0.4,animations: {self.topLabel.alpha=0}, completion: { completed in
            if (completed==true){self.topLabel.removeFromSuperview()}
        })
    }

    
    @IBAction func onSlider(_ sender: UISlider) {
        // print("on slider")
        // print( sliderValue )
        sliderValue = Int(sender.value)
        // sliderValue = roundUp(Int(sender.value), divisor: 1000)
        if lightenButton.isSelected == true {
            filteredImage = LightenFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if darkenButton.isSelected == true {
            filteredImage = DarkenFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if contrastButton.isSelected == true {
            //print( sliderValue )
            filteredImage = ContrastFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if greyButton.isSelected == true {
            filteredImage = GreyFilter(percentage: sliderValue!).filter( originalImage! )
        }
        if bwButton.isSelected == true {
            filteredImage = BnWFilter(percentage: sliderValue!).filter( originalImage! )
        }
        imageView.image = filteredImage
    }
   
    @IBAction func onLightenFilter(_ sender: UIButton) {
        if lightenButton.isSelected {
            lightenButton.isSelected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.isEnabled = false
            hideSliderMenu()
        } else {
            lightenButton.isSelected    = true
            darkenButton.isSelected  = false
            contrastButton.isSelected   = false
            greyButton.isSelected   = false
            bwButton.isSelected     = false
            compareButton.isEnabled = true
            filteredImage = LightenFilter(percentage: 75).filter( originalImage! )
            showSliderMenu()
            imageView.image = filteredImage
        }
    }

    @IBAction func onDarkenFilter(_ sender: UIButton) {
        if darkenButton.isSelected {
            darkenButton.isSelected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.isEnabled = false
        } else {
            lightenButton.isSelected    = false
            darkenButton.isSelected  = true
            contrastButton.isSelected   = false
            greyButton.isSelected   = false
            bwButton.isSelected     = false
            compareButton.isEnabled = true
            filteredImage = DarkenFilter(percentage: 75).filter( originalImage! )
            showSliderMenu()
            imageView.image = filteredImage
        }
    }
    
    @IBAction func onContrastFilter(_ sender: UIButton) {
        if contrastButton.isSelected {
            contrastButton.isSelected = false
            imageView.image = originalImage
            // if no other compare buttons are selected
            compareButton.isEnabled = false
        } else {
            lightenButton.isSelected    = false
            darkenButton.isSelected  = false
            contrastButton.isSelected   = true
            greyButton.isSelected   = false
            bwButton.isSelected     = false
            compareButton.isEnabled = true
            filteredImage = ContrastFilter(percentage: 75).filter( originalImage! )
            showSliderMenu()
            imageView.image = filteredImage
        }
    }
    
    @IBAction func onGreyFilter(_ sender: UIButton) {
        if greyButton.isSelected {
            greyButton.isSelected = false
            imageView.image = originalImage
        } else {
            lightenButton.isSelected    = false
            darkenButton.isSelected  = false
            contrastButton.isSelected   = false
            greyButton.isSelected   = true
            bwButton.isSelected     = false
            compareButton.isEnabled = true
            filteredImage = GreyFilter(percentage: 75).filter( originalImage! )
            showSliderMenu()
            imageView.image = filteredImage
        }
    }
    
    @IBAction func onBWFilter(_ sender: UIButton) {
        if bwButton.isSelected {
            bwButton.isSelected = false
            imageView.image = originalImage
        } else {
            lightenButton.isSelected    = false
            darkenButton.isSelected  = false
            contrastButton.isSelected   = false
            greyButton.isSelected   = false
            bwButton.isSelected     = true
            compareButton.isEnabled = true
            filteredImage = BnWFilter(percentage: 75).filter( originalImage! )
            showSliderMenu()
            imageView.image = filteredImage
        }
    }
    
    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            filteredImage   = nil
            originalImage   = newImage
            imageView.image = newImage
            compareButton.isEnabled = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }

    func showSliderMenu() {
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraint(equalTo: secondaryMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraint(equalToConstant: 45)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderMenu.alpha = 1.0
        }) 
    }
    
    func hideSliderMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }) 
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 45)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 1.0
        }) 
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }) 
    }

}
