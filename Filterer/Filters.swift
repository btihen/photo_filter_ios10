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

public struct ContrastFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage * 2 - 100
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
                var pixel     = newImage!.pixels[index]
                let diffRed   = Double(p) / 100.0 * ( Double(pixel.red)   - 128) + 128
                let diffGreen = Double(p) / 100.0 * ( Double(pixel.green) - 128) + 128
                let diffBlue  = Double(p) / 100.0 * ( Double(pixel.blue)  - 128) + 128
                pixel.red     = UInt8( max( 0, min(255, Int(diffRed)) ) )
                pixel.green   = UInt8( max( 0, min(255, Int(diffGreen)) ) )
                pixel.blue    = UInt8( max( 0, min(255, Int(diffBlue)) ) )
                newImage!.pixels[index] = pixel
            }
        }
        return (newImage!.toUIImage())!
    }
}

public struct LightenFilter {
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
                var pixel     = newImage!.pixels[index]
                let liteRed   = Double(pixel.red)   + (255 - Double(pixel.red  )) * Double(p) / 100.0
                let liteGreen = Double(pixel.green) + (255 - Double(pixel.green)) * Double(p) / 100.0
                let liteBlue  = Double(pixel.blue)  + (255 - Double(pixel.blue )) * Double(p) / 100.0
                pixel.red     = UInt8( max( 0, min(255, Int(liteRed)) ) )
                pixel.green   = UInt8( max( 0, min(255, Int(liteGreen)) ) )
                pixel.blue    = UInt8( max( 0, min(255, Int(liteBlue)) ) )
                newImage!.pixels[index] = pixel
            }
        }
        return (newImage!.toUIImage())!
    }
}
public struct DarkenFilter {
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
                var pixel     = newImage!.pixels[index]
                let darkRed   = Double(pixel.red)   * Double(p) / 100.0
                let darkGreen = Double(pixel.green) * Double(p) / 100.0
                let darkBlue  = Double(pixel.blue)  * Double(p) / 100.0
                pixel.red     = UInt8( max( 0, min(255, Int(darkRed)) ) )
                pixel.green   = UInt8( max( 0, min(255, Int(darkGreen)) ) )
                pixel.blue    = UInt8( max( 0, min(255, Int(darkBlue)) ) )
                newImage!.pixels[index] = pixel
            }
        }
        return (newImage!.toUIImage())!
    }
}

public struct GreyFilter {
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
                var pixel     = newImage!.pixels[index]
                let totBright = Double(pixel.red) + Double(pixel.green) + Double(pixel.blue)
                let avgBright = totBright / 3.0 * Double(p) / 100.0
                pixel.red     = UInt8( max( 0, min(255, Int(avgBright)) ) )
                pixel.green   = UInt8( max( 0, min(255, Int(avgBright)) ) )
                pixel.blue    = UInt8( max( 0, min(255, Int(avgBright)) ) )
                newImage!.pixels[index] = pixel
            }
        }
        return (newImage!.toUIImage())!
    }
}

public struct BnWFilter {
    public var p: Int
    
    public init(percentage: Int) {
        p = percentage * 2 - 100
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
        var avg: Int = sum / (newImage!.height * newImage!.width)
        avg = (avg - avg * p / 100)
        
        for row in 0..<newImage!.height {
            for col in 0..<newImage!.width {
                index = row * newImage!.width + col
                var pixel     = newImage!.pixels[index]
                let totBright = Double(pixel.red) + Double(pixel.green) + Double(pixel.blue)
                let avgBright = totBright / 3.0
                if Int(avgBright) < avg {
                    pixel.red     = UInt8( 0 )
                    pixel.green   = UInt8( 0 )
                    pixel.blue    = UInt8( 0 )
                } else {
                    pixel.red     = UInt8( 255 )
                    pixel.green   = UInt8( 255 )
                    pixel.blue    = UInt8( 255 )
                }
                newImage!.pixels[index] = pixel
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

