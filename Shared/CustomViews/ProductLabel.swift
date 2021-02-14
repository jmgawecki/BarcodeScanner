//
//  ProductLabel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 11/02/2021.
//

import SwiftUI

struct ProductLabel: View {
    @Binding var item: ProductStored?
    var systemImageString: String?
    
    var body: some View {
        HStack {
            if ((item?.productName?.isEmpty) != nil) {
                Label((item?.productName)!,
                      systemImage: systemImageString ?? "xcross")
                    .font(.headline)
                    .padding()
            } else {
                Label("No product's name available",
                      systemImage: systemImageString ?? "xcross")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
        }
    }
}

struct ProductLabel_Previews: PreviewProvider {
    static var previews: some View {
        ProductLabel(item: .constant(MockData.sample2))
    }
}