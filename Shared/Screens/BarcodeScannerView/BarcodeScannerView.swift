//
//  BarcodeScannerView.swift
//  Shared
//
//  Created by Jakub Gawecki on 06/02/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismiss: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "test",
                                              dismiss: .default(Text("Ok")))
    static let invalidScanType = AlertItem(title: "Invalid ScanType",
                                              message: "test",
                                              dismiss: .default(Text("Ok")))
}

struct BarcodeScannerView: View {
    /// We are going to bind it in our ScannerView initialising moment.
    
    @StateObject private var viewModel = ScannerViewModel()
    
    
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    ScannerView(scannedCode: $viewModel.scannedCode,
                                alertItem: $viewModel.alertItem)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                    
                    Spacer().frame(height: 60)
                    
                    ScannedCodeLabel()
                    
                    CodeDisplayer(scannedCode: $viewModel.scannedCode)
                    
                    if !viewModel.scannedCode.isEmpty {
                        GetInfoButton(didRequestProductInfo: $viewModel.didRequestProductInfo,
                                      scannedCode: $viewModel.scannedCode)
                    } else {
                        GetInfoButton(didRequestProductInfo: $viewModel.didRequestProductInfo,
                                      scannedCode: $viewModel.scannedCode).hidden()
                    }
                    
                    
                    
                }
                .navigationTitle("Barcode Scanner")
                .sheet(isPresented: $viewModel.didRequestProductInfo, content: {
                    ProductDetail(item: $viewModel.selectedProduct,
                                  image: $viewModel.productImage,
                                  productToBeAdded: $viewModel.productToBeAdded,
                                  addedFetchedToFavorite: $viewModel.addedFetchedToFavorite)
                })
            }
            .tabItem {
                Text("First Tab")
                Image(systemName: "phone.fill")
            }
            NavigationView {
                VStack {
                    List {
                        Group {
                            if viewModel.favoriteProducts.isEmpty {
                                Text("No favorites")
                            } else {
                                ForEach(viewModel.favoriteProducts, id: \.id) { product in
                                    ProductRowView(productItem: product)
                                        .onTapGesture {
                                            viewModel.selectedFavorite = product
                                        }
                                }
                            }
                        }
                    }
                    .onAppear { viewModel.loadProducts() }
                }
                .sheet(isPresented: $viewModel.isShowingFavDetail, content: {
                    FavProductDetail(item: $viewModel.selectedFavorite, image: $viewModel.favProductImage)
                })
            }
            .tabItem {
                Text("Second tab")
                Image(systemName: "phone.fill")
            }
            
        }
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}

struct CodeDisplayer: View {
    @Binding var scannedCode: String
    var body: some View {
        Text(scannedCode.isEmpty ? "NOT YET SCANNED" : scannedCode)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(scannedCode.isEmpty ? Color(.red) : Color(.green))
            .padding()
    }
}

struct ScannedCodeLabel: View {
    var body: some View {
        Label("Scanned Barcode:", systemImage: "barcode.viewfinder")
            .font(.title)
    }
}

struct GetInfoButton: View {
    @Binding var didRequestProductInfo: Bool
    @Binding var scannedCode: String
    var body: some View {
        Button(action: {
            didRequestProductInfo.toggle()
        }, label: {
            Text("Get info!")
                .padding()
                .frame(width: 150, height: 50, alignment: .center)
                .background(Color.green)
                .cornerRadius(15)
            
        })
    }
}
