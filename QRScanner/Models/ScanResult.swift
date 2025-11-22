//
//  ScanResult.swift
//  QRScanner
//
//  Created by Joel on 22/11/25.
//

import Foundation

struct ScanResult: Identifiable, Codable {
    let id: UUID
    let content: String
    let date: Date
    
    init(id: UUID = UUID(), content: String, date: Date = Date()) {
        self.id = id
        self.content = content
        self.date = date
    }
}
