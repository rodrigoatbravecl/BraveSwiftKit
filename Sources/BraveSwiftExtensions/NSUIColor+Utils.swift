//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/14/21.
//

import SwiftUI

public extension NSUIColor {
    // [0, 1]
    var bcComponenteR: CGFloat {
        self.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)!.components![0]
    }
    
    // [0, 1]
    var bcComponenteG: CGFloat {
        self.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)!.components![1]
    }
    
    // [0, 1]
    var bcComponenteB: CGFloat {
        self.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)!.components![2]
    }
    
    // [0, 1]
    var bcComponenteA: CGFloat {
        self.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)!.components![3]
    }
}

