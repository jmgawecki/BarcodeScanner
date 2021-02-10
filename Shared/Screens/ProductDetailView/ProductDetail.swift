//
//  ProductDetail.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import SwiftUI

struct ProductDetail: View {
    
    @Binding var item: ProductLocal?
    @Binding var image: Image?
    @Binding var productToBeAdded: ProductStored?
    @Binding var addedFetchedToFavorite: Bool
    
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
                
                Button(action: {
                    productToBeAdded = ProductStored(barcode: item!.barcodeNumber,
                                                     productName: item?.productName,
                                                     category: item?.category,
                                                     brand: item?.brand,
                                                     image: item?.image)
                    addedFetchedToFavorite.toggle()
                    print(addedFetchedToFavorite)
                }, label: {
                    Text("Add to favorite")
                        .padding()
                })
                Spacer(minLength: 170)
            }
        }
    }
}

//struct ProductDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetail(item: .constant(MockData.sample), image: .constant(Image("mockupImage")))
//    }
//}
