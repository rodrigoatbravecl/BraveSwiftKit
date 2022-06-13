//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/1/21.
//

import Foundation

public extension String {
    func encodedURL() -> URL? {
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        
        return URL(string: encodedString)
    }
}
