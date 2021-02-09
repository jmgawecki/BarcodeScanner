// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "c91f55873219679c5265ad1911b0ba10"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductStored.self)
  }
}