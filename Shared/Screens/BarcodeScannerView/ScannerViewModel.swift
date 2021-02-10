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
    var selectedProduct: ProductStored?
    
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
        didSet { if !scannedCode.isEmpty { getProductInfo() } }
    }
    
    
    // MARK: - Image related Publishers
    
    
    @Published var didCloseFavProductDetail = false {
        didSet {
            productImage = nil
        }
    }
    
    @Published var productImage: Image?
    
    
    @Published var scannedCode = ""
    
    
    // MARK: - Conditional Publishers
    
    
    @Published var alertItem: AlertItem?
    
    
    /// That publisher gives a value to one of the cases from ActiveSheet enumeration. Based on a result from getProductInfo() network call, will present either CreateProductView.swift (case failure) or ProductDetail.swift (case success).
    @Published var activeSheet: ActiveSheet?

    
    //MARK: - Data Store Functions
    
    
    /// Loads products from AWS Amplify Data Store. Saves products to local array favoriteProducts
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
                self.getProductImage(from: (self.selectedProduct?.image)!)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activeSheet = .create
                }
                print(error)
            }
        }
    }
    
    
    private func getProductImage(from urlString: String) {
        NetworkManager.shared.downloadImage(with: urlString) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.productImage = image
            }
        }
    }
}
