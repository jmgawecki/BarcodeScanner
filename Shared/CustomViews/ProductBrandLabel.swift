//
//  ProductBrandLabel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 11/02/2021.
//

import SwiftUI

struct ProductBrandLabel: View {
    @Binding var item: ProductStored?
    
    var body: some View {
        
        HStack {
            if ((item?.brand!) != "") {
                Label(" \((item?.brand)!)", systemImage: "building")
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                Label(" No product's brand available", systemImage: "building")
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
    }
}
