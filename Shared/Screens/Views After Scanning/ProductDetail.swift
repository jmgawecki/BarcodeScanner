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
                
                BarcodeLabel(item: $selectedProduct)
                
                ProductDetailImageView(image: $image)
                
                ProductLabel(item: $selectedProduct,
                             systemImageString: SystemImages.productsName)
                
                ProductBrandLabel(item: $selectedProduct)
                
                ProductLabel(item: $selectedProduct,
                             systemImageString: SystemImages.productsCategory)
                
                
                Button(action: {
                    fetchedProductFromJson = ProductStored(barcode: selectedProduct!.barcode,
                                                     productName: selectedProduct?.productName,
                                                     category: selectedProduct?.category,
                                                     brand: selectedProduct?.brand,
                                                     image: selectedProduct?.image)
                }, label: {
                    Text("Add to favorite")
                        .padding()
                        .foregroundColor(.green)
                       
                })
                Spacer().frame(minHeight: 10, maxHeight: 80)
            }
        }
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetail(selectedProduct: .constant(MockData.sample2),
                      image: .constant(Image("mockupImage")),
                      fetchedProductFromJson: .constant(MockData.sample2))
            .preferredColorScheme(.dark)
    }
}

/*
 BarcodeLabel(item: $item)
 
 ProductDetailImageView(image: $image)
 
 ProductLabel(item: $item, systemImageString: SystemImages.productsName)
 
 ProductBrandLabel(item: $item)
 
 ProductLabel(item: $item, systemImageString: SystemImages.productsCategory)

 Spacer(minLength: 30)*/

