//
//  CreateProductView.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 10/02/2021.
//

import SwiftUI

struct CreateProductView: View {
    @Binding var createdProductManually: ProductStored?
    
    @Binding var barcode: String
    @State var productName: String = ""
    @State var brand: String = ""
    @State var category: String = ""
    @State var image: String = ""
    
    
    var body: some View {
        Group {
            VStack {
                Text("We do not recognise that barcode 🧐")
                    .font(.headline)
                    .padding(.bottom)
                Text("Fill that form to add it to your library!")
                    .font(.subheadline)
                List {
                    Section(header: Text("Barcode")) {
                        TextField("", text: $barcode).disabled(true)
                            .foregroundColor(.gray)
                    }
                    Section(header: Text("Name")) {
                        TextField("", text: $productName)
                    }
                    Section(header: Text("Brand")) {
                        TextField("", text: $brand)
                    }
                    Section(header: Text("Category")) {
                        TextField("", text: $category)
                    }
                }
                .listStyle(GroupedListStyle())
                Button(action: {
                    if productName.isEmpty {
                        productName = "Test1"
                    }
                    #warning("Later on you can check and refactor for productToBeCreated to didSet instead of addedToFavorite.toggle")
                    createdProductManually = ProductStored(barcode: barcode,
                                                       productName: productName,
                                                       category: category,
                                                       brand: brand,
                                                       image: image)
                    
                }, label: {
                    Text("Add to favorite!")
                })
            }
        }
    }
}

//struct CreateProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateProductView(viewModel: <#ScannerViewModel#>, barcode: .constant("1214235135")
//    }
//}
