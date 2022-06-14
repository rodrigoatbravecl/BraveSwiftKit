//
//  File.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/14/22.
//

#if os(macOS)
import AppKit

public typealias NSUIImage = NSImage
#elseif os(iOS)
import UIKit

public typealias NSUIImage = UIImage
#endif
