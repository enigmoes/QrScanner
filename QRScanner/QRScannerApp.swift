//
//  QRScannerApp.swift
//  QRScanner
//
//  Created by Joel on 20/3/23.
//

import SwiftUI

@main
struct QRScannerApp: App {
    var body: some Scene {
        WindowGroup {
            ScannerView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
