//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 4/19/21.
//

import SwiftUI
import ImageIO

public extension URL {
    func resizedImage(for size: CGSize) -> NSUIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        
        guard let imageSource = CGImageSourceCreateWithURL(self as NSURL, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }
        
        return NSUIImage(cgImage: image)
    }
}
