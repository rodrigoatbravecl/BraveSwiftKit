//
//  NSImage+diff.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/13/22.
//

import Foundation
import CoreImage

public extension NSUIImage {
    static func diffCompare(image: NSUIImage?, with anotherImage: NSUIImage?, ignoreMeta: Bool = false) -> Bool {
        guard let cgImage1 = image?.cgImage, let cgAnotherImage = anotherImage?.cgImage else {
            return false
        }
        
        if ImageDiff.doImagesHaveSameMeta(image1: cgImage1, image2: cgAnotherImage) || ignoreMeta {
            if let cRes = try? ImageDiff.compare(leftImage: cgImage1, rightImage: cgAnotherImage) {
                return cRes == 0
            }
        }
        
        return false
    }
}

/**
 Based on: https://gist.github.com/SheffieldKevin/566dc048dd6f36716bcd
 Updated for Swift 5.5 (Xcode 13)
 */
fileprivate class ImageDiff {
    
    /**
     @brief Returns true if images have same meta. Width, Height, bit depth.
     @discussion Assumes images are non null.
     */
    static func doImagesHaveSameMeta(image1: CGImage, image2: CGImage) -> Bool {
        if image1.width != image2.width {
            return false
        }
        
        if image1.height != image2.height {
            return false
        }
        
        if image1.bitsPerComponent != image2.bitsPerComponent {
            return false
        }
        
        if image1.bytesPerRow != image2.bytesPerRow {
            return false
        }
        
        if image1.bitsPerPixel != image2.bitsPerPixel {
            return false
        }
        
        return true
    }
    
    static func compare(leftImage: CGImage, rightImage: CGImage) throws -> Int {
        
        let left = CIImage(cgImage: leftImage)
        let right = CIImage(cgImage: rightImage)
        
        guard let diffFilter = CIFilter(name: "CIDifferenceBlendMode") else {
            throw ImageDiffError.failedToCreateFilter
        }
        diffFilter.setDefaults()
        diffFilter.setValue(left, forKey: kCIInputImageKey)
        diffFilter.setValue(right, forKey: kCIInputBackgroundImageKey)
        
        // Create the area max filter and set its properties.
        guard let areaMaxFilter = CIFilter(name: "CIAreaMaximum") else {
            throw ImageDiffError.failedToCreateFilter
        }
        areaMaxFilter.setDefaults()
        areaMaxFilter.setValue(diffFilter.value(forKey: kCIOutputImageKey),
                               forKey: kCIInputImageKey)
        let compareRect = CGRect(x: 0, y: 0, width: CGFloat(leftImage.width), height: CGFloat(leftImage.height))
        
        let extents = CIVector(cgRect: compareRect)
        areaMaxFilter.setValue(extents, forKey: kCIInputExtentKey)
        
        // The filters have been setup, now set up the CGContext bitmap context the
        // output is drawn to. Setup the context with our supplied buffer.
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bitmapInfo = CGBitmapInfo(rawValue: alphaInfo.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var buf: [CUnsignedChar] = Array<CUnsignedChar>(repeating: 255, count: 16)
        
        guard let context = CGContext(
            data: &buf,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 16,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            throw ImageDiffError.failedToCreateContext
        }
        
        // Now create the core image context CIContext from the bitmap context.
        let ciContextOpts = [
            CIContextOption.workingColorSpace : colorSpace,
            CIContextOption.useSoftwareRenderer : false
        ] as [CIContextOption : Any]
        let ciContext = CIContext(cgContext: context, options: ciContextOpts)
        
        // Get the output CIImage and draw that to the Core Image context.
        let valueImage = areaMaxFilter.value(forKey: kCIOutputImageKey)! as! CIImage
        ciContext.draw(valueImage, in: CGRect(x: 0, y: 0, width: 1, height: 1),
                       from: valueImage.extent)
        
        // This will have modified the contents of the buffer used for the CGContext.
        // Find the maximum value of the different color components. Remember that
        // the CGContext was created with a Premultiplied last meaning that alpha
        // is the fourth component with red, green and blue in the first three.
        let maxVal = max(buf[0], max(buf[1], buf[2]))
        let diff = Int(maxVal)
        
        return diff
    }
}

// MARK: - Supporting Types
fileprivate enum ImageDiffError: LocalizedError {
    case failedToCreateFilter
    case failedToCreateContext
}

