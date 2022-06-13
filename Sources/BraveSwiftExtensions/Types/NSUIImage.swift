//
//  File.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/13/22.
//

import SwiftUI

#if os(macOS)
public typealias NSUIImage = NSImage
#endif

#if os(iOS)
public typealias NSUIImage = UIImage
#endif
