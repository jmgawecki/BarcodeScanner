//
//  ProductDetailImageView.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 11/02/2021.
//

import SwiftUI

struct ProductDetailImageView: View {
    @Binding var image: Image?
    
    var body: some View {
        (image ?? Image(systemName: "cross"))
            .resizable()
            .frame(width: 250, height: 250, alignment: .center)
            .cornerRadius(50)
    }
}
