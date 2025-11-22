//
//  HistoryView.swift
//  QRScanner
//
//  Created by Joel on 22/11/25.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingScanner = false
    @State private var selectedScan: ScanResult?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.scans.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("No hay escaneos")
                            .font(.title2)
                            .foregroundColor(.gray)
                        HStack(spacing: 4) {
                            Text("Toca el botón")
                            Image(systemName: "camera")
                                .font(.subheadline)
                            Text("para escanear un QR")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.scans) { scan in
                            Button {
                                selectedScan = scan
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(scan.content)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                    Text(formatDate(scan.date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = viewModel.scans.firstIndex(where: { $0.id == scan.id }) {
                                        viewModel.deleteScan(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Historial QR")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingScanner = true
                    } label: {
                        Image(systemName: "camera")
                            .font(.system(size: 16))
                    }
                }
                
                if !viewModel.scans.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingScanner) {
                ScannerView { scannedCode in
                    viewModel.addScan(scannedCode)
                    showingScanner = false
                }
            }
            .sheet(item: $selectedScan) { scan in
                SheetView(QrCode: .constant(scan.content))
            }
            .alert("Eliminar todo", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    viewModel.deleteAllScans()
                }
            } message: {
                Text("¿Estás seguro de que quieres eliminar todos los escaneos?")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
