//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 4/18/21.
//

import SwiftUI

public extension NSUIImage{
#if os(macOS)
    convenience init(cgImage: CGImage){
        self.init(cgImage: cgImage, size: .zero)
    }
    
    var ciImage: CIImage? {
        get {
#if os(macOS)
            guard let imagem = self.tiffRepresentation else { return nil }
            
            return CIImage(data: imagem)
#endif
            
            //      #if os(iOS)
            //      return CIImage(image: self)
            //      #endif
        }
    }
#endif
    
#if os(macOS)
    var cgImage: CGImage? {
        get {
            return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
        }
    }
#endif
    
    //  #if os(iOS)
    //  convenience init?(contentsOf url: URL) {
    //    try? self.init(url: url)!
    //  }
    //  #endif
}
