//
//  FavProductDetail.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 10/02/2021.
//

import SwiftUI

import SwiftUI

struct FavProductDetail: View {
    
    @Binding var selectedProduct: ProductStored?
    @Binding var image: Image?
    @Binding var didCloseFavProductDetail: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                BarcodeLabel(item: $selectedProduct)
                
                ProductDetailImageView(image: $image)
                
                ProductNameLabel(item: $selectedProduct, systemImageString: SystemImages.productsName)
                
                ProductBrandLabel(item: $selectedProduct)
                
                ProductCategoryLabel(item: $selectedProduct, systemImageString: SystemImages.productsCategory)
               
                Spacer(minLength: 30)
            }
        }
        .onDisappear {
            didCloseFavProductDetail.toggle()
            image = nil
        }
        .onAppear {
            print(selectedProduct)
        }
    }
}


//MARK: - Preview


struct FavProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        FavProductDetail(selectedProduct: .constant(MockData.sample2),
                         image: .constant(Image("mockupImage")),
                         didCloseFavProductDetail: .constant(false))
            .preferredColorScheme(.dark)
    }
}


//MARK: - Views







