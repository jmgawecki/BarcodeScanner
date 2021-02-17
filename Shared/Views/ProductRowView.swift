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
            HStack {
                Text(productItem.productName!)
                    .font(.headline)
                Spacer()
            }
            
            if productItem.brand != "" {
                HStack {
                    Text("From ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(productItem.brand!)
                        .frame(alignment: .center)
                        .font(.headline)
                    Spacer()
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
