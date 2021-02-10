//
//  FavProductDetail.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 10/02/2021.
//

import SwiftUI

import SwiftUI

struct FavProductDetail: View {
    
    @Binding var item: ProductStored?
    @Binding var image: Image?
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                (image ?? Image(systemName: "cross"))
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                
                Text(item?.productName ?? "No product's name available")
                    .font(.headline)
                    .padding(.vertical)
                
                Text(item?.category ?? "No product's category available")
                    .font(.subheadline)
                
                Text(item?.brand ?? "Product's brand unknown")
                Spacer(minLength: 170)
            }
        }
    }
}

//struct FavProductDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetail(item: .constant(MockData.sample), image: .constant(Image("mockupImage")))
//    }
//}
