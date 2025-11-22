//
//  ScannerView.swift
//  QRScanner
//
//  Created by Joel on 22/3/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ScannerViewModel()
    var onScanComplete: ((String) -> Void)?
    
    var qrCodeScannerView = QrCodeScannerView()

    let previewCornerRadius: CGFloat = 15.0
    
    init(onScanComplete: ((String) -> Void)? = nil) {
        self.onScanComplete = onScanComplete
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                qrCodeScannerView
                    .setSession(getSession: self.viewModel.session)
                    .found(r: self.viewModel.onFoundQrCode)
                    .torchLight(isOn: self.viewModel.torchIsOn)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear { self.viewModel.startSession() }
                    .onDisappear { self.viewModel.pauseSession() }
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        self.viewModel.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 28))
                            .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.white)
                            .padding(12)
                    })
                }
                .padding(.bottom, 50)
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationTitle("Escanear QR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingSheet, onDismiss: {
                if let callback = onScanComplete {
                    callback(self.viewModel.lastQrCode)
                }
                self.viewModel.lastQrCode = ""
                self.viewModel.showingSheet = false
                
                self.viewModel.startSession()
            }, content: {
                SheetView(QrCode: $viewModel.lastQrCode)
            })
        }
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var QrCode: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text(self.QrCode)
                    .bold()
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
            .navigationTitle(Text("QrCode"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        UIPasteboard.general.setValue(self.QrCode, forPasteboardType: UTType.plainText.identifier)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 14))
                            Text("Copiar")
                        }
                        .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}
