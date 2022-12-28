//: [Previous](@previous)

import Foundation

let numbers = (1...10).publisher

numbers.drop(while: { $0 % 3 != 0 })
    .sink { print($0) }



//: [Next](@next)
