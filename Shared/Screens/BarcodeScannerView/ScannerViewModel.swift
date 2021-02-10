//
//  BarcodeScannerViewModel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 09/02/2021.
//

import SwiftUI
import Amplify
import AmplifyPlugins

enum ActiveSheet: Identifiable {
    case detail, create
    
    var id: Int {
        hashValue
    }
}

final class ScannerViewModel: ObservableObject {
    
    
    //MARK: - Declarations
    
    @Published var productToBeCreated: ProductStored?
    @Published var productToBeAdded: ProductStored?
    
    @Published var activeSheet: ActiveSheet?
    
    @Published var favoriteProducts: [ProductStored] = []
    
    @Published var selectedFavorite: ProductStored? {
        didSet {
            isShowingFavDetail = true
            getFavProductsImage(from: (selectedFavorite?.image)!)
        }
    }
    
    var selectedProduct: ProductLocal?
//    { didSet { isShowingDetail = true } }
    
//    @Published var isShowingCreateProduct = false
    
    @Published var scannedCode = ""
    
    @Published var didRequestProductInfo = false {
        didSet { if !scannedCode.isEmpty { getProductInfo() } }
    }
    
    @Published var productImage: Image?
    @Published var favProductImage: Image?
    @Published var addedCreatedToFavorite = false {
        didSet {
            createNSaveProductFromStored(from: productToBeCreated!)
            activeSheet = nil
        }
    }
    @Published var addedFetchedToFavorite = false {
        didSet {
            createNSaveProductFromStored(from: productToBeAdded!)
            activeSheet = nil
        }
    }
    
    @Published var isShowingFavDetail = false
    
    @Published var alertItem: AlertItem?
    
    func getImage() {
        
    }
    
    
    //MARK: - Data Store Functions
    
    func loadProducts() {
        Amplify.DataStore.query(ProductStored.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.favoriteProducts.removeAll()
                self.favoriteProducts = products
            case .failure(let error):
                print("Error in loadProducts: \(error)")
            }
        }
    }
    
    func createNSaveProductFromLocal(from product: ProductLocal) {
        let productStored = ProductStored(barcode: product.barcodeNumber,
                                          productName: product.productName,
                                          category: product.category,
                                          brand: product.brand,
                                          image: product.image)
        favoriteProducts.append(productStored)
        Amplify.DataStore.save(productStored) { (result) in
            switch result {
            case .success(let item):
                print("SUCCESS! \n Saved \(item)")
            case .failure(let error):
                print("Error in createNSaveProducts: \(error)")
            }
        }
    }
    
    func createNSaveProductFromStored(from product: ProductStored) {
        favoriteProducts.append(product)
        Amplify.DataStore.save(product) { (result) in
            switch result {
            case .success(let item):
                print("SUCCESS! \n Saved \(item)")
            case .failure(let error):
                print("Error in createNSaveProducts: \(error)")
            }
        }
    }
    
    
    //MARK: - Network Calls
    
    private func getProductInfo() {
        NetworkManager.shared.getProduct(barcode: scannedCode) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.selectedProduct = product
                    self.activeSheet = .detail
                }
                self.getProductsImage(from: product.image!)
            case .failure(let error):
//                self.isShowingCreateProduct.toggle()
                DispatchQueue.main.async {
                    self.activeSheet = .create
                }
               
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
    
    private func getFavProductsImage(from urlString: String) {
        NetworkManager.shared.downloadImage(with: urlString) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.favProductImage = image
            }
        }
    }
    
}
