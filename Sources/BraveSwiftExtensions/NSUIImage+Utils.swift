//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 4/19/21.
//

import SwiftUI

#if os(macOS)
import Quartz
#endif

public extension NSUIImage{
    var flippedHorizontally: NSUIImage {
        get {
#if os(macOS)
            let flipedImage = NSImage(size: self.size)
            flipedImage.lockFocus()
            
            let t = NSAffineTransform.init()
            t.translateX(by: size.width, yBy: 0.0)
            t.scaleX(by: -1.0, yBy: 1.0)
            t.concat()
            
            self.draw(in: NSRect(origin: CGPoint.zero, size: size))
            flipedImage.unlockFocus()
            return flipedImage
#endif
            
#if os(iOS)
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: size.width, y: 0)
            context.scaleBy(x: -1, y: 1)
            
            draw(in: CGRect(origin: .zero, size: size))
            let flipped = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return flipped!
#endif
        }
    }
    
    var flippedVertically: NSUIImage {
        get {
#if os(macOS)
            let flipedImage = NSImage(size: self.size)
            flipedImage.lockFocus()
            
            let t = NSAffineTransform.init()
            t.translateX(by: 0, yBy: size.height)
            t.scaleX(by: 1.0, yBy: -1.0)
            t.concat()
            
            self.draw(in: NSRect(origin: CGPoint.zero, size: size))
            flipedImage.unlockFocus()
            return flipedImage
#endif
            
#if os(iOS)
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()!
            
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            
            draw(in: CGRect(origin: .zero, size: size))
            let flipped = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return flipped!
#endif
        }
    }
    
    var rotateRight: NSUIImage {
        get {
            return self.imageRotated(by: 90)
        }
    }
    
    var rotateLeft: NSUIImage {
        get {
            return self.imageRotated(by: -90)
        }
    }
    
#if os(macOS)
    func imageRotated(by degrees: CGFloat) -> NSImage {
        let imageRotator = IKImageView()
        var imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        imageRotator.setImage(cgImage, imageProperties: [:])
        imageRotator.rotationAngle = CGFloat(-(degrees / 180) * CGFloat(Double.pi))
        let rotatedCGImage = imageRotator.image().takeUnretainedValue()
        return NSImage(cgImage: rotatedCGImage, size: NSSize.zero)
    }
#endif
    
#if os(iOS)
    func imageRotated(by degrees: CGFloat) -> UIImage {
        let radians = CGFloat((degrees / 180) * CGFloat(Double.pi))
        
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //  func imageRotated(by degrees: CGFloat) -> UIImage {
    //    let radians = CGFloat((degrees / 180) * CGFloat(Double.pi))
    //
    //    let rotatedSize = CGRect(origin: .zero, size: size)
    //      .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
    //      .integral.size
    //    UIGraphicsBeginImageContext(rotatedSize)
    //    if let context = UIGraphicsGetCurrentContext() {
    //      let origin = CGPoint(x: rotatedSize.width / 2.0,
    //                           y: rotatedSize.height / 2.0)
    //      context.translateBy(x: origin.x, y: origin.y)
    //      context.rotate(by: radians)
    //      draw(in: CGRect(x: -origin.y, y: -origin.x,
    //                      width: size.width, height: size.height))
    //      let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
    //      UIGraphicsEndImageContext()
    //
    //      return rotatedImage ?? self
    //    }
    //
    //    return self
    //  }
#endif
    
#if os(iOS)
    var fixOrientation: UIImage {
        if (imageOrientation == .up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
#endif
    
    var data: Data? {
        get {
#if os(macOS)
            return self.tiffRepresentation
#endif
            
#if os(iOS)
            return self.pngData()
#endif
        }
    }
}
