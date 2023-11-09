//
//  ScannerViewModel.swift
//  QRScanner
//
//  Created by Joel on 20/3/23.
//

import Foundation
import AVFoundation

class ScannerViewModel: ObservableObject {
    // let scanInterval: Double = 1.0
    
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    @Published var showingSheet: Bool = false
    
    /// This private property holds the current state of the session. The app uses this to pause the app
    /// when it goes into the background and to resume the app when it comes back to the foreground.
    private var isSessionRunning = false

    /// This queue is used to communicate with the session and other session objects.
    private let sessionQueue = DispatchQueue(label: "QrCodeScannerView: sessionQueue")
    
    @Published var session: AVCaptureSession
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.showingSheet = true
        
        self.pauseSession()
    }
    
    init() {
        session = AVCaptureSession()
    }
    
    func startSession() {
        dispatchPrecondition(condition: .onQueue(.main))
        sessionQueue.async {
            self.session.startRunning()
            self.isSessionRunning = self.session.isRunning
        }
    }

    func pauseSession() {
        dispatchPrecondition(condition: .onQueue(.main))
        sessionQueue.async {
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }
    }
    
    func getSession() -> AVCaptureSession {
        return self.session
    }
}
