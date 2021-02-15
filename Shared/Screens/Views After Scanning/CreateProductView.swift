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
                Spacer(minLength: 30)
                HStack {
                    Text("We do not recognise that barcode 🧐")
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                }
                
                HStack {
                    Text("Fill that form to add it to your library!")
                        .font(.subheadline)
                        .padding(.leading)
                    Spacer()
                }
                
                
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
                    
                    createdProductManually = ProductStored(barcode: barcode,
                                                       productName: productName,
                                                       category: category,
                                                       brand: brand,
                                                       image: image)
                }, label: {
                    Text("Add to favorite!")
                })
                .frame(width: 140, height: 44, alignment: .center)
                .foregroundColor(.green)
            }
        }
    }
}

struct CreateProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProductView(createdProductManually: .constant(MockData.sample2),
                          barcode: .constant("32415423534"))
            .preferredColorScheme(.dark)
    }
}
