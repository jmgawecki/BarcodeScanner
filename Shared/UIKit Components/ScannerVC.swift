//
//  CameraView.swift
//  Barcode Scanner (iOS)
//
//  Created by Jakub Gawecki on 06/02/2021.
//

import SwiftUI
import UIKit
/// Camera Framework
import AVFoundation

enum CameraError {
    case invalidDeviceInput
    case invalidScannedValue
}

/// Protocol for communication with the main View
protocol ScannerVCDelegate: class {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}


/// Classic VC from UIKit
final class ScannerVC: UIViewController {
    
    /// Capturing what's on the camera
    let captureSession = AVCaptureSession()
    
    /// It's what is displaying on the screen as you moving the camera
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    /// Delegate for our delegates. This is the final object, out String value that we are going to pass to another View/VC
    weak var scannerDelegate: ScannerVCDelegate?
    
    
    /// Initialiser for our VC
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    
    
    /// All the set up for our camera looking for barcodes
    private func setupCaptureSession() {
        /// That checks if we have a device that can capture a video
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        ///
        let videoInput: AVCaptureDeviceInput
        
        /// Catchblock for checking if we have a divice input from videCaptureDevice. If we do the we assign it to videoInput of tapy AVCaptureDeviceInput
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        /// we check if we can input from videoInput to our captureSession
        if captureSession.canAddInput(videoInput) {
            /// if we can let's add that input
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        /// this is what get's scanned
        let metaDataOutput = AVCaptureMetadataOutput()
        
        /// We check if we can add output
        if captureSession.canAddOutput(metaDataOutput) {
            /// If we can let's add that output
            captureSession.addOutput(metaDataOutput)
            /// We set the delegate here
            /// To make that work we need to conform to the delegate (below in extension)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            /// this is type of objects that our metadataOutput is going to look for
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        /// now we are initalising our previewLayer passing our captureSession that we did all those checks on
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        /// whatever view we create on the design, fill that view but keep you aspect ratio
        previewLayer!.videoGravity = .resizeAspectFill
        /// Now let's add that previewLayer to our view
        view.layer.addSublayer(previewLayer!)
        
        /// lets run our session
        captureSession.startRunning()
    }
}

/// Conforming to delegates (Our delegate is going to be an coordinator
/// Now we tell our coordinator what to do once the object that we are looking for is being captured
extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        /// we just want to take the first object out of our array of found objects
        /// in reality its going to execute scanning object all the time so its always going to be the first object, at least in that specific example
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        /// We need to check if that object is machine readable
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }

        /// We want the string value that machineReadableObject has and we substract it so we can use it
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }

        captureSession.stopRunning()
        /// that assing that barcode that we found to our scannerDelegate
        scannerDelegate?.didFind(barcode: barcode)
    }
}
