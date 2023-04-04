//
//  ScannerViewModel.swift
//  QRScanner
//
//  Created by Joel on 20/3/23.
//

import Foundation

class ScannerViewModel: ObservableObject {
    // let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    @Published var showingSheet: Bool = false
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.showingSheet = true
    }
}
