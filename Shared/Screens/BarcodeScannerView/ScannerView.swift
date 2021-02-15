//
//  BarcodeScannerView.swift
//  Shared
//
//  Created by Jakub Gawecki on 06/02/2021.
//

import SwiftUI



struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
  
        TabView {
            NavigationView {
            List {
                if viewModel.favoriteProducts.isEmpty {
                    EmptyStateList()
                } else {
                    ForEach(viewModel.favoriteProducts, id: \.id) { product in
                        ProductRowView(productItem: product)
                            .onTapGesture {
                                viewModel.selectedFavorite = product
                            }
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.deleteProduct(at: indexSet)
                        viewModel.reloadProducts()
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear { viewModel.reloadProducts() }
            .sheet(isPresented: $viewModel.isShowingFavDetail, content: {
                FavProductDetail(selectedProduct: $viewModel.selectedFavorite,
                                 image: $viewModel.productImage,
                                 didCloseFavProductDetail: $viewModel.didCloseFavProductDetail)
            })
            
            .navigationTitle("Your products")
            
        }
            .tabItem {
                Text("Your products")
                Image(systemName: "star")
            }
            NavigationView {
                VStack {
                    ScannerViewAV(scannedCode: $viewModel.scannedCode,
                                  alertItem: $viewModel.alertItem)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(75)
                    
                    Spacer().frame(minHeight: 30, maxHeight: 100)
                    
                    ScannedCodeLabel()
                    
                    CodeDisplayer(scannedCode: $viewModel.scannedCode)
                    
                    if viewModel.isButtonVisible {
                        GetProductDetailsButton(didRequestProductFromJson: $viewModel.didRequestProductFromJson,
                                                scannedCode: $viewModel.scannedCode, isButtonVisible: $viewModel.isButtonVisible)
                    } else {
                        GetProductDetailsButton(didRequestProductFromJson: $viewModel.didRequestProductFromJson,
                                                scannedCode: $viewModel.scannedCode, isButtonVisible: $viewModel.isButtonVisible).hidden()
                    }
                }
                .navigationTitle("Scanner")
                .sheet(item: $viewModel.activeSheet) { item in
                    switch item {
                    case .detail:
                        ProductDetail(selectedProduct: $viewModel.selectedProduct,
                                      image: $viewModel.productImage,
                                      fetchedProductFromJson: $viewModel.fetchedProductFromJson, didScanFromCloud: $viewModel.didScanFromCloud)
                        
                    case .create:
                        CreateProductView(createdProductManually: $viewModel.createdProductManually,
                                          barcode: $viewModel.scannedCode)
                    }
                }
            }
            .tabItem {
                Text("Scanner")
                Image(systemName: "barcode.viewfinder")
            }
            
            
        }
    }
}



// MARK:- Preview


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
            .preferredColorScheme(.light)
            
            
            
    }
}


// MARK: - Custom Views


struct CodeDisplayer: View {
    @Binding var scannedCode: String
    var body: some View {
        Text(scannedCode.isEmpty ? "Not scanned yet" : scannedCode)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(scannedCode.isEmpty ? Color(.systemPink) : Color(.systemGreen))
            .padding(.bottom)
        
    }
}

struct ScannedCodeLabel: View {
    var body: some View {
        Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
            .font(.title)
    }
}

struct GetProductDetailsButton: View {
    @Binding var didRequestProductFromJson: Bool
    @Binding var scannedCode: String
    @Binding var isButtonVisible: Bool
    var body: some View {
        Button(action: {
            didRequestProductFromJson.toggle()
            isButtonVisible.toggle()
        }, label: {
            Text("Get info!")
                .frame(width: 150, height: 50, alignment: .center)
                .background(Color.green)
                .cornerRadius(15)
            
        })
        .padding(.bottom)
    }
}

struct EmptyStateList: View {
    var body: some View {
        Text("No favorites")
            .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .padding()
    }
}
