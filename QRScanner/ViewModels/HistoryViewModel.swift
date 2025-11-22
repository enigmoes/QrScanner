//
//  HistoryViewModel.swift
//  QRScanner
//
//  Created by Joel on 22/11/25.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var scans: [ScanResult] = []
    
    private let userDefaultsKey = "qr_scans"
    
    init() {
        loadScans()
    }
    
    func addScan(_ content: String) {
        let newScan = ScanResult(content: content)
        scans.insert(newScan, at: 0) // Más recientes primero
        saveScans()
    }
    
    func deleteScan(at offsets: IndexSet) {
        scans.remove(atOffsets: offsets)
        saveScans()
    }
    
    func deleteAllScans() {
        scans.removeAll()
        saveScans()
    }
    
    private func saveScans() {
        if let encoded = try? JSONEncoder().encode(scans) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadScans() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([ScanResult].self, from: data) {
            scans = decoded
        }
    }
}
