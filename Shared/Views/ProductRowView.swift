//
//  ProductRowView.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 10/02/2021.
//

import SwiftUI

struct ProductRowView: View {
    
    let productItem: ProductStored
    
    
    var body: some View {
        VStack {
            Text(productItem.productName!)
                .font(.headline)
            Text(productItem.category ?? "")
                .font(.subheadline)
        }
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRowView(productItem: MockData.sample2)
    }
}
