//
//  Data+Extensions.swift
//
//
//  Created by Rodrigo Dutra on 5/1/21.
//

#if os(macOS)
import Foundation

extension Data {
    public func sha256Hash() -> Data {
        let transform = SecDigestTransformCreate(kSecDigestSHA2, 256, nil)
        SecTransformSetAttribute(transform, kSecTransformInputAttributeName, self as CFTypeRef, nil)
        return SecTransformExecute(transform, nil) as! Data
    }
    
    public func uniqueHash() -> String {
        return sha256Hash().base64EncodedString()
    }
    
    /**
     It returns the size of the image whose data is given as a parameter value.
     
     - Returns: A CGSize value or nil if no NSImage can be created from the
     parameter data.
     */
    public func getImageSize() -> CGSize? {
        guard let image = NSUIImage(data: self) else { return nil }
        return image.size
    }
}
#endif
