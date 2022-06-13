//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/1/21.
//

#if os(macOS)
import Foundation

public extension NSMutableAttributedString {
    
    @discardableResult func setAsLink(textToFind: String, link: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        
        guard let encodedLink = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let url = URL(string: encodedLink) else {
            return false
        }
        
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: url, range: foundRange)
            return true
        }
        
        return false
    }
}
#endif
