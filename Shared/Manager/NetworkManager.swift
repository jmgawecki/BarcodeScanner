//
//  NetworkManager.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import SwiftUI

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getProduct(barcode: String, completed: @escaping(Result<ProductLocal,ScanError>) -> Void) {
        let urlString = "https://api.barcodelookup.com/v2/products?barcode=\(barcode)&formatted=y&key=fuuyc2efcj8b2w0jjp08n8xx76arm7"
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error { completed(.failure(.error)) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let product = try decoder.decode(Item.self, from: data)
                let localProduct = ProductLocal(barcodeNumber: product.products[0].barcodeNumber,
                                                productName: product.products[0].productName,
                                                category: product.products[0].category,
                                                brand: product.products[0].brand,
                                                image: product.products[0].images?[0])
                completed(.success(localProduct))
                
            } catch {
                completed(.failure(.chatchError))
            }
        }
        dataTask.resume()
    }
    
    func downloadImage(with urlString: String, completed: @escaping(Image) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
                let image = Image(uiImage: UIImage(data: data)!)
                completed(image)
        }
        dataTask.resume()
    }
}
