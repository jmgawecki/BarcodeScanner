//
//  BarcodeScannerView.swift
//  Shared
//
//  Created by Jakub Gawecki on 06/02/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismiss: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "test",
                                              dismiss: .default(Text("Ok")))
    static let invalidScanType = AlertItem(title: "Invalid ScanType",
                                              message: "test",
                                              dismiss: .default(Text("Ok")))
}

struct BarcodeScannerView: View {
    /// We are going to bind it in our ScannerView initialising moment.
    
    @StateObject private var viewModel = BarcodeScannerViewModel()
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedCode: $viewModel.scannedCode,
                            alertItem: $viewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 60)
                
                Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                CodeDisplayer(scannedCode: $viewModel.scannedCode)
                    .padding()
            }
            
            .navigationTitle("Barcode Scanner")
            .sheet(isPresented: $viewModel.isShowingDetail, content: {
                ProductDetail(item: $viewModel.selectedProduct, image: $viewModel.productImage)
            })
            
            
        }
        
        
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}

struct CodeDisplayer: View {
    @Binding var scannedCode: String
    var body: some View {
        Text(scannedCode.isEmpty ? "NOT YET SCANNED" : scannedCode)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(scannedCode.isEmpty ? Color(.red) : Color(.green))
    }
}
