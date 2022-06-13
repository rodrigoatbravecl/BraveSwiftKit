//
//  File.swift
//  
//
//  Created by Rodrigo Dutra on 5/1/21.
//

#if os(macOS)
import Cocoa

public extension NSImage {
    
    var jpegData: Data? {
        return tiffRepresentation(using: .jpeg, factor: 1.0)
    }
    
    /// Resize image with aspect fill
    ///
    /// - Parameter newSize: size of the resized image
    /// - Returns: scaled image
    func resized(to newSize: NSSize) -> NSImage? {
        guard let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            return nil
        }
        
        let scale: CGFloat = max(newSize.width / self.size.width, newSize.height / self.size.height)
        let width: CGFloat = self.size.width * scale
        let height: CGFloat = self.size.height * scale
        let imageRect = CGRect(x: (newSize.width - width) / 2.0,
                               y: (newSize.height - height) / 2.0,
                               width: width, height: height)
        
        bitmapRep.size = newSize
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
        draw(in: imageRect)
        NSGraphicsContext.restoreGraphicsState()
        
        let resizedImage = NSImage(size: newSize)
        resizedImage.addRepresentation(bitmapRep)
        
        return resizedImage
    }
    
    /// SwifterSwift: Compressed NSImage from original NSImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.7).
    /// - Returns: optional NSImage (if applicable).
    func compressed(quality: Float = 0.7) -> NSImage? {
        guard let data = compressedData(quality: quality) else {
            return nil
        }
        return NSImage(data: data)
    }
    
    /// SwifterSwift: Compressed NSImage data from original NSImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.7).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: Float = 0.7) -> Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        
        let options: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: quality
        ]
        
        return bitmapRep.representation(using: .jpeg, properties: options)
    }
    
    func isEqual(to image: NSImage?) -> Bool {
        guard let image = image else {
            return false
        }
        
        let data1 = self.tiffRepresentation
        let data2 = image.tiffRepresentation
        return data1 == data2
    }
    
    func uniqueHash() -> String {
        return self.tiffRepresentation!.sha256Hash().base64EncodedString()
    }
    
    func tinting(with tintColor: NSColor) -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return self }
        
        return NSImage(size: size, flipped: false) { bounds in
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            tintColor.set()
            context.clip(to: bounds, mask: cgImage)
            context.fill(bounds)
            return true
        }
    }
}
#endif
