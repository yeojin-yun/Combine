//: [Previous](@previous)

import Foundation
import Combine

let numbers = (1...8).publisher

numbers.filter { $0 % 2 == 0 }
    .sink { print("filtering value is",$0)}

//: [Next](@next)
