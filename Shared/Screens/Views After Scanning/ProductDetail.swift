//
//  ProductDetail.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import SwiftUI

struct ProductDetail: View {
    
    @Binding var selectedProduct: ProductStored?
    @Binding var image: Image?
    @Binding var fetchedProductFromJson: ProductStored?
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                (image ?? Image(systemName: "cross"))
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                
                let extractedExpr: Text = Text(selectedProduct?.productName ?? "No product's name available")
                extractedExpr
                    .font(.headline)
                    .padding(.vertical)
                
                Text(selectedProduct?.category ?? "No product's category available")
                    .font(.subheadline)
                
                Text(selectedProduct?.brand ?? "Product's brand unknown")
                
                Button(action: {
                    fetchedProductFromJson = ProductStored(barcode: selectedProduct!.barcode,
                                                     productName: selectedProduct?.productName,
                                                     category: selectedProduct?.category,
                                                     brand: selectedProduct?.brand,
                                                     image: selectedProduct?.image)
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
