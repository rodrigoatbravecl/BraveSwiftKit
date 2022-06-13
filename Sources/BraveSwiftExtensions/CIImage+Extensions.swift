//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 4/19/21.
//
import SwiftUI

#if os(macOS)
public extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func tinted(using color: NSColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
    
    func nsImage() -> NSImage{
        let rep: NSCIImageRep = NSCIImageRep(ciImage: self)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage!
    }
}

public extension CIImage {
    /// Create a CGImage version of this image
    ///
    /// - Returns: Converted image, or nil
    func asCGImage(context: CIContext? = nil) -> CGImage? {
        let ctx = context ?? CIContext(options: nil)
        return ctx.createCGImage(self, from: self.extent)
    }
    /// Create an NSImage version of this image
    /// - Parameters:
    ///   - pixelSize: The number of pixels in the result image. For a retina image (for example), pixelSize is double repSize
    ///   - repSize: The number of points in the result image
    /// - Returns: Converted image, or nil
#if os(macOS)
    @available(macOS 10, *)
    func asNSImage(pixelsSize: CGSize? = nil, repSize: CGSize? = nil) -> NSImage? {
        let rep = NSCIImageRep(ciImage: self)
        if let ps = pixelsSize {
            rep.pixelsWide = Int(ps.width)
            rep.pixelsHigh = Int(ps.height)
        }
        if let rs = repSize {
            rep.size = rs
        }
        let updateImage = NSImage(size: rep.size)
        updateImage.addRepresentation(rep)
        return updateImage
    }
#endif
}

public extension CGImage {
    /// Create a CIImage version of this image
    ///
    /// - Returns: Converted image, or nil
    func asCIImage() -> CIImage {
        return CIImage(cgImage: self)
    }
    /// Create an NSImage version of this image
    ///
    /// - Returns: Converted image, or nil
    func asNSImage() -> NSImage? {
        return NSImage(cgImage: self, size: .zero)
    }
}
#endif

#if os(iOS)
public extension CGImage {
    /// Create a CIImage version of this image
    ///
    /// - Returns: Converted image, or nil
    func asCIImage() -> CIImage {
        return CIImage(cgImage: self)
    }
    /// Create an NSImage version of this image
    ///
    /// - Returns: Converted image, or nil
    func asUIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
#endif
