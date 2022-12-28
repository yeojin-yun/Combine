//: [Previous](@previous)

import Foundation

let numbers = (1...10).publisher

numbers.dropFirst(8)
    .sink { print($0) }

//9, 10

//: [Next](@next)
