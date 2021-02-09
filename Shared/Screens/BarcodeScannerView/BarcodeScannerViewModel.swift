//
//  BarcodeScannerViewModel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 09/02/2021.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    
    var selectedProduct: Item? {
        didSet { isShowingDetail = true }
    }
    
    @Published var scannedCode = "" {
        didSet {
            if !scannedCode.isEmpty { getProductInfo() }
        }
    }
    
    @Published var productImage: Image?
    
    @Published var isShowingDetail = false
    
    @Published var alertItem: AlertItem?
    
    
    private func getProductInfo() {
        NetworkManager.shared.getProduct(barcode: scannedCode) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.selectedProduct = product
                }
                print(product)
                self.getProductsImage(from: product.products[0].images![0])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getProductsImage(from urlString: String) {
        NetworkManager.shared.downloadImage(with: urlString) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.productImage = image
            }
        }
    }
}
