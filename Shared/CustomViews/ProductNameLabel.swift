//
//  ProductLabel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 11/02/2021.
//

import SwiftUI

struct ProductNameLabel: View {
    @Binding var item: ProductStored?
    var systemImageString: String?
    
    var body: some View {
        HStack {
            if ((item?.productName!) != "") {
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
        ProductNameLabel(item: .constant(MockData.sample2))
    }
}
