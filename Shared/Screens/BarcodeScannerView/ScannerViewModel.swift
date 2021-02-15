//
//  BarcodeScannerViewModel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 09/02/2021.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import UIKit

enum ActiveSheet: Identifiable {
    case detail, create
    
    var id: Int {
        hashValue
    }
}

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

final class ScannerViewModel: ObservableObject {
    
    
    //MARK: - Main Logic UI Publishers
    var selectedProduct:    ProductStored?
    var didFoundProductInCloud = false
    
    
    @Published var favoriteProducts:    [ProductStored] = []
    
    
    /// That publisher fires the function that will save newly created product in CreateProductView.swift to Amplify Data Store. Object will be saved to local array favoriteProducts. Publisher will dismiss CreateProductView.swift
    @Published var createdProductManually:  ProductStored? {
        didSet {
            uploadProductToCloud(from: createdProductManually!)
            activeSheet = nil
        }
    }
    
    
    /// That publisher fires the function that will save newly fetched product from Json in ProductDetail.swift to Amplify Data Store. Object will be saved to local array favoriteProducts. Publisher will dismiss ProductDetail.swift
    @Published var fetchedProductFromJson:  ProductStored? {
        didSet {
            uploadProductToCloud(from: fetchedProductFromJson!)
            activeSheet = nil
        }
    }
    
 
    /// That publisher will present FavProductDetail.swift and execute downloading the product's image from Json
    @Published var selectedFavorite:    ProductStored? {
        didSet {
            isShowingFavDetail = true
            getProductImage(from: (selectedFavorite?.image)!)
        }
    }
    
    @Published var isShowingFavDetail = false
    
    
    /// That publisher execute getProductInfo() network call when button GetProductDetailsButton(...) is tapped in ScannerView.swift.
    @Published var didRequestProductFromJson = false {
        didSet {
            if !scannedCode.isEmpty { findProductInCloud()
            }
        }
    }
    
    
    // MARK: - Image related Publishers
    
    
    @Published var didCloseFavProductDetail = false {
        didSet {
            productImage = nil
        }
    }
    
    @Published var productImage: Image?
    
    
    @Published var scannedCode = "" {
        didSet {
            withAnimation {
                isButtonVisible.toggle()
            }
        }
    }
    
    @Published var isButtonVisible = false
    
    
    // MARK: - Conditional Publishers
    
    
    @Published var alertItem: AlertItem?
    
    
    /// That publisher gives a value to one of the cases from ActiveSheet enumeration. Based on a result from getProductInfo() network call, will present either CreateProductView.swift (case failure) or ProductDetail.swift (case success).
    @Published var activeSheet: ActiveSheet?

    
    //MARK: - Data Store Functions
    func findProductInCloud() {
        Amplify.DataStore.query(ProductStored.self) { (result) in
            switch result {
            case .success(let products):
                var tempProducts: [ProductStored]?
                tempProducts = products.filter({ $0.barcode == scannedCode})
                print(tempProducts)
                guard ((tempProducts?.isEmpty) == nil) else {
                    DispatchQueue.main.async {
                        self.selectedProduct = tempProducts?[0]
                        self.activeSheet = .detail
                    }
                    self.getProductImage(from: (tempProducts![0].image)!)
                    return
                }
                
                getProductInfo()
                
                
            case .failure(let error):
                print("Error in loadProducts: \(error)")
            }
        }
    }
    
    
    /// Loads products from AWS Amplify Data Store. Saves products to local array favoriteProducts
    func reloadProducts() {
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

    
    /// Uploads single product to AWS Amplify Data Store
    /// - Parameter product: product that is going to be uploaded in AWS Amplify Data Store
    func uploadProductToCloud(from product: ProductStored) {
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
    
    
    func deleteProduct(at offsets: IndexSet, from productsfavList: inout [ProductStored]) {
        for index in offsets {
            let product = productsfavList[index]
            deleteFromCloud(product: product)
        }
        favoriteProducts.remove(atOffsets: offsets)
    }
    
    
    func deleteFromCloud(product: ProductStored) {
        Amplify.DataStore.delete(product) { result in
            switch result {
            case .success():
                print("product with the id: \(product.id) deleted!")
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func deleteProduct(at offsets: IndexSet) {
      deleteProduct(at: offsets, from: &favoriteProducts)
    }
    
    
    
    
    
    //MARK: - Network Calls
    
    
    private func getProductInfo() {
        NetworkManager.shared.getProduct(barcode: scannedCode) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self.selectedProduct = ProductStored(barcode: product.barcodeNumber,
                                                         productName: product.productName,
                                                         category: product.category,
                                                         brand: product.brand,
                                                         image: product.image)
                    self.activeSheet = .detail
                }
                self.getProductImage(from: (product.image)!)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activeSheet = .create
                }
                print(error)
            }
        }
    }
    
    
    private func getProductImage(from urlString: String?) {
        guard urlString != nil else { return }
        
        NetworkManager.shared.downloadImage(with: urlString!) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.productImage = image
            }
        }
    }
}
