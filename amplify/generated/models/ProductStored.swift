// swiftlint:disable all
import Amplify
import Foundation

public struct ProductStored: Model {
  public let id: String
  public var barcode: String
  public var productName: String?
  public var category: String?
  public var brand: String?
  public var image: String?
  
  public init(id: String = UUID().uuidString,
      barcode: String,
      productName: String? = nil,
      category: String? = nil,
      brand: String? = nil,
      image: String? = nil) {
      self.id = id
      self.barcode = barcode
      self.productName = productName
      self.category = category
      self.brand = brand
      self.image = image
  }
}
