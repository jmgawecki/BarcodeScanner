//
//  ProductCategoryLabel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 15/02/2021.
//

import SwiftUI

struct ProductCategoryLabel: View {
    @Binding var item: ProductStored?
    var systemImageString: String?
    
    var body: some View {
        HStack {
            if ((item?.category!) != "") {
                Label((item?.category)!,
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

struct ProductCategoryLabel_Previews: PreviewProvider {
    static var previews: some View {
        ProductNameLabel(item: .constant(MockData.sample2))
    }
}
