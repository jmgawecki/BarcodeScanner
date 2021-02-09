//
//  ScanError.swift
//  Barcode Scanner
//
//  Created by Jakub Gawecki on 08/02/2021.
//

import Foundation

enum ScanError: String, Error {
    case invalidURL         = "invalid Url"
    case error              = "error received"
    case invalidResponse    = "response error"
    case invalidData        = "invalid data received"
    case chatchError        = "error during a catch"
}


