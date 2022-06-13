//
//  File.swift
//  
//
//  Created by Rodrigo Dutra de Oliveira on 6/13/22.
//

import SwiftUI

#if os(macOS)
public typealias NSUIColor = NSColor
#endif

#if os(iOS)
public typealias NSUIColor = UIColor
#endif
