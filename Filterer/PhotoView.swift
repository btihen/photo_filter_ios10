//
//  PhotoView.swift
//  Filterer
//
//  Created by Bill Tihen on 22.01.17.
//  Copyright © 2017 UofT. All rights reserved.
//

import UIKit


class PhotoView: UIImageView {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print("touches began")
//        imageView.image = originalImage
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("touches ended")
//        imageView.image = filteredImage
    }
    
}
