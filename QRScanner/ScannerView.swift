//
//  ScannerView.swift
//  QRScanner
//
//  Created by Joel on 22/3/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScannerView: View {
    @ObservedObject var viewModel = ScannerViewModel()
    
    var qrCodeScannerView = QrCodeScannerView()

    let previewCornerRadius: CGFloat = 15.0
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                        Text("QR Scanner")
                            .foregroundColor(.white)
                        qrCodeScannerView
                            .setSession(getSession: self.viewModel.session)
                            .found(r: self.viewModel.onFoundQrCode)
                            .torchLight(isOn: self.viewModel.torchIsOn)
                            // .interval(delay: self.viewModel.scanInterval)
                            .clipShape(RoundedRectangle(cornerRadius: previewCornerRadius))
                            .onAppear { self.viewModel.startSession() }
                            .onDisappear { self.viewModel.pauseSession() }
                            .overlay(
                                Image("ObjectReticle")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.all))
                    }
                    HStack {
                        Button(action: {
                            self.viewModel.torchIsOn.toggle()
                        }, label: {
                            Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                                .imageScale(.large)
                                .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                                .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 15))
                        })
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .sheet(isPresented: $viewModel.showingSheet, onDismiss: {
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
            .navigationTitle(Text("QrCode"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        UIPasteboard.general.setValue(self.QrCode, forPasteboardType: UTType.plainText.identifier)
                    } label: {
                        HStack {
                            Image(systemName: "doc.on.clipboard.fill")
                            Text("Copy")
                        }
                        .frame(width: 100, height: 45)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}
