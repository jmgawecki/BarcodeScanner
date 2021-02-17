//
//  Barcode_ScannerTests.swift
//  Barcode ScannerTests
//
//  Created by Jakub Gawecki on 17/02/2021.
//

import XCTest
@testable import Barcode_Scanner

class Barcode_ScannerTests: XCTestCase {
    var urlTest: URLSession!

    override func setUpWithError() throws {
        super.setUp()
        urlTest = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        urlTest = nil
        super.tearDown()
        
    }
    
    func testCallToBarcodeCompleted() {
        // given
        let url             = URL(string: "https://api.barcodelookup.com/v2/products?barcode=0140157379&formatted=y&key=fuuyc2efcj8b2w0jjp08n8xx76arm7")
        
        let promise         = expectation(description: "Completion handler invoked")
        var statusCode:     Int?
        var responseError:  Error?
        
        
        // when
        let dataTask = urlTest.dataTask(with: url!) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        
        //then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
