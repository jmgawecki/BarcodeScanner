//
//  ScannerView.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
    
    /// that replaces out view for SwiftUI files
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    /// You dont do updates so its an empty implementation
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) { }
    
    /// When we did create class Coordinator below, we need to confrom to it and this where this function is coming from
    /// se first create that class below and then add stubs automatically
    func makeCoordinator() -> Coordinator {
        /// We initialise our coordinator that we created below
        /// later on we add private let scannerView to our coordinator so when its initialised we need to pass that value. It is going to be self. Self its struct ScannerView from what I understand
        Coordinator(scannerView: self)
    }
    
    /// Our coordinator is basically our delegate of Scanner VC so it needs to conform to its delegates
    /// hit fixes to conform to delegates didFind, didSurface
    /// That is the moment when ScnnerVC delegate pass the data to that ScannerView and from now on we con do something with it
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        /// That is for creating a connection between our Coordinator and out scannerView
        private let scannerView: ScannerView
        
        /// normal uikit initialising
        init(scannerView: ScannerView) { self.scannerView = scannerView }
        
        /// this is binding to our ScannerView's struct scannedCode,
        /// that is passed onto ScannerView where UI changes are executed
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
        }
        
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScanType
            }
        }
    }
}
