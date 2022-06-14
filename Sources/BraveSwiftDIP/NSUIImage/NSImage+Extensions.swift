//
//  NSImage+Extensions.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/13/22.
//

#if os(macOS)
import AppKit

public extension NSImage {
    var ciImage: CIImage? {
        get {
            if let data = self.tiffRepresentation {
                return CIImage(data: data)
            }
            
            return nil
        }
    }
    
    var cgImage: CGImage? {
        get {
            var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: self.size)
            return self.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
        }
    }
}

public extension CIImage {
    var nsImage: NSImage {
        get {
            let rep = NSCIImageRep(ciImage: self)
            
            let updateImage = NSImage(size: rep.size)
            updateImage.addRepresentation(rep)
            return updateImage
        }
    }
    
    var cgImage: CGImage? {
        get {
            let ctx = CIContext(options: nil)
            return ctx.createCGImage(self, from: self.extent)
        }
    }
}

public extension CGImage {
    var ciImage: CIImage? {
        get {
            return CIImage(cgImage: self)
        }
    }
    
    var nsImage: NSImage? {
        get {
            return NSImage(cgImage: self, size: .zero)
        }
    }
}

#endif
