//
//  Barcode_ScannerApp.swift
//  Shared
//
//  Created by Jakub Gawecki on 06/02/2021.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct Barcode_ScannerApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        runAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            BarcodeScannerView()
        }
    }
}

private func runAmplify() {
    let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
    do {
        try Amplify.add(plugin: apiPlugin)
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialised")
    } catch {
        print("Could not initialise Amplify: \(error)")
    }
}
