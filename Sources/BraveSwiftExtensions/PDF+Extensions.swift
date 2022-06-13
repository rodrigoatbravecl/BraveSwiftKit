//
//  File.swift
//
//
//  Created by Rodrigo Dutra on 8/23/21.
//

import PDFKit

public extension PDFDocument {
    func addPages(from document: PDFDocument) {
        let pageCountAddition = document.pageCount
        
        for pageIndex in 0..<pageCountAddition {
            guard let addPage = document.page(at: pageIndex) else {
                break
            }
            
            self.insert(addPage, at: self.pageCount)
        }
    }
    
}
