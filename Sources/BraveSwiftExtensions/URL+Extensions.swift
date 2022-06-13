//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 5/7/21.
//

#if os(macOS)
import SwiftUI

extension URL {
    public var isDirectory: Bool? {
        do {
            let values = try self.resourceValues(
                forKeys:Set([URLResourceKey.isDirectoryKey])
            )
            return values.isDirectory
        } catch  { return nil }
    }
}

public extension URL{
    func showInFinder() {
        
        if let _ = self.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.path)
        }else {
            showInFinderAndSelectLastComponent(of: self)
        }
    }
    
    func showInFinderAndSelectLastComponent(of url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

#endif
