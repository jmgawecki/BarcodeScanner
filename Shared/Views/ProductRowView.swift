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
            if productItem.category != "" {
                HStack {
                    Text("From ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(productItem.brand!)
                        .frame(alignment: .center)
                        .font(.headline)
                }
                
            }
        }
        .frame(maxWidth: .infinity,
               minHeight: 60)
        .cornerRadius(15)
        
        
        
        
        
        
        
        
        
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRowView(productItem: MockData.sample2)
            .preferredColorScheme(.dark)
    }
}
