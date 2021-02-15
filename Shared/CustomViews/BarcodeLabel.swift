//
//  BarcodeLabel.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 11/02/2021.
//

import SwiftUI

struct BarcodeLabel: View {
    @Binding var item: ProductStored?
    
    var body: some View {
        if ((item?.productName!) != "") {
            Label((item?.barcode)!, systemImage: "barcode.viewfinder")
                .foregroundColor(.green)
                .font(.title)
        } else {
            Label("No barcode available", systemImage: "barcode.viewfinder")
                .foregroundColor(.green)
                .font(.title)
        }
    }
}
