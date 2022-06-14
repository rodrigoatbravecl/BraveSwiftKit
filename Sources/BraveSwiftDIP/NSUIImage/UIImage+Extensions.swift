//
//  UIImage+Extensions.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/13/22.
//

#if os(iOS)
import UIKit

public extension UIImage {
    var ciImage: CIImage? {
        get {
            return self.cgImage?.ciImage
        }
    }
}

public extension CIImage {
    var uiImage: UIImage {
        get {
            return UIImage(ciImage: self)
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
    
    var uiImage: UIImage? {
        get {
            return UIImage(cgImage: self)
        }
    }
}

#endif
