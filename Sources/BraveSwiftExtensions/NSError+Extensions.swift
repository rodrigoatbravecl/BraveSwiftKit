//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/1/21.
//

#if os(macOS)
import Foundation

public extension NSError {
    
    convenience init(code: Int = 1, description: String) {
        self.init(
            domain: "com.bravecl",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }
}
#endif
