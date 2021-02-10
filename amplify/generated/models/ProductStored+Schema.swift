// swiftlint:disable all
import Amplify
import Foundation

extension ProductStored {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case barcode
    case productName
    case category
    case brand
    case image
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let productStored = ProductStored.keys
    
    model.pluralName = "ProductStoreds"
    
    model.fields(
      .id(),
      .field(productStored.barcode, is: .required, ofType: .string),
      .field(productStored.productName, is: .optional, ofType: .string),
      .field(productStored.category, is: .optional, ofType: .string),
      .field(productStored.brand, is: .optional, ofType: .string),
      .field(productStored.image, is: .optional, ofType: .string)
    )
    }
}
