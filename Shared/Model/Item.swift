//
//  Product.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import Foundation

struct Item: Codable {
    var products: [Product]
}

struct Product: Codable {
    let barcodeNumber:  String      // barcode_number
    var productName:    String?     // product_name
    var category:       String?     // category
    var brand:          String?     // brand
    var images:         [String]?   // images
}

struct MockData {
    static let sample: ProductLocal =
    ProductLocal(barcodeNumber: "2345345354",
            productName: "Haroun and the Sea of Stories",
            category: "Media > Books > Print Books",
            brand: "Penguin Books",
            image: "https://images.barcodelookup.com/134/1342375-1.jpg")
    
    static let sample2: ProductStored =
    ProductStored(barcode: "2345345354",
            productName: "Haroun and the Sea of Stories",
            category: "Media > Books > Print Books",
            brand: "Penguin Books",
            image: "https://images.barcodelookup.com/134/1342375-1.jpg")
    
    
}

struct ProductLocal {
    let barcodeNumber:  String
    var productName:    String?
    var category:       String?
    var brand:          String?
    var image:          String?
}

