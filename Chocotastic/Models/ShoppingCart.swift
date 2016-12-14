

import Foundation
import RxSwift

class ShoppingCart {
  
  static let sharedCart = ShoppingCart()
  
  let chocolates: Variable<[Chocolate]> = Variable([])
  
  //MARK: Non-Mutating Functions
  
  func totalCost() -> Float {
    return chocolates.value.reduce(0) {
      runningTotal, chocolate in
      return runningTotal + chocolate.priceInDollars
    }
  }
  
  func itemCountString() -> String {
    guard chocolates.value.count > 0 else {
      return "🚫🍫"
    }
    
    //Unique the chocolates
    let setOfChocolates = Set<Chocolate>(chocolates.value)
    
    //Check how many of each exists
    let itemStrings: [String] = setOfChocolates.map {
      chocolate in
      let count: Int = chocolates.value.reduce(0) {
        runningTotal, reduceChocolate in
        if chocolate == reduceChocolate {
          return runningTotal + 1
        }
        
        return runningTotal
      }
      
      return "\(chocolate.countryFlagEmoji)🍫: \(count)"
    }
    
    return itemStrings.joined(separator: "\n")
  }
  
}
