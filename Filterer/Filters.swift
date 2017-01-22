//
//  Filters.swift
//  Filterer
//
//  Created by Bill Tihen on 22.01.17.
//  Copyright © 2017 UofT. All rights reserved.
//

import Foundation

import UIKit

public struct OpacityFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage
    }
    
    public func filter(image: UIImage) -> UIImage {
        var newImage = RGBAImage(image: image)
        if newImage == nil {
            print("Image open failed.")
            return image
        }
        var index: Int
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                newImage!.pixels[index].alpha = UInt8(max(0, min(255, Int(newImage!.pixels[index].alpha) * p / 100)))
            }
        }
        return (newImage!.toUIImage())!
    }
}

public struct RedFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage
    }
    
    public func filter(image: UIImage) -> UIImage {
        var newImage = RGBAImage(image: image)
        if newImage == nil {
            print("Image open failed.")
            return image
        }
        var index: Int
        var sum: Int = 0
        
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                sum = sum + Int(newImage!.pixels[index].red)
            }
        }
        let avg: Int = sum / (newImage!.height * newImage!.width)
        
        var diff: Int
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                diff = Int(newImage!.pixels[index].red) - avg
                newImage!.pixels[index].red = UInt8(max(0, min(255, avg + diff * p / 100)))
            }
        }
        return (newImage!.toUIImage())!
    }
}


public struct GreenFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage
    }
    
    public func filter(image: UIImage) -> UIImage {
        var newImage = RGBAImage(image: image)
        if newImage == nil {
            print("Image open failed.")
            return image
        }
        var index: Int
        var sum: Int = 0
        
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                sum = sum + Int(newImage!.pixels[index].green)
            }
        }
        let avg: Int = sum / (newImage!.height * newImage!.width)
        
        var diff: Int
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                diff = Int(newImage!.pixels[index].green) - avg
                newImage!.pixels[index].green = UInt8(max(0, min(255, avg + diff * p / 100)))
            }
        }
        return (newImage!.toUIImage())!
    }
}


public struct BlueFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage
    }
    
    public func filter(image: UIImage) -> UIImage {
        var newImage = RGBAImage(image: image)
        if newImage == nil {
            print("Image open failed.")
            return image
        }
        var index: Int
        var sum: Int = 0
        
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                sum = sum + Int(newImage!.pixels[index].blue)
            }
        }
        let avg: Int = sum / (newImage!.height * newImage!.width)
        
        var diff: Int
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                diff = Int(newImage!.pixels[index].blue) - avg
                newImage!.pixels[index].blue = UInt8(max(0, min(255, avg + diff * p / 100)))
            }
        }
        return (newImage!.toUIImage())!
    }
}

