//: [Previous](@previous)

import Foundation


let numbers = (1...9).publisher

numbers.last(where: { $0 % 2 == 0 })
    .sink { print($0) }

//8

//: [Next](@next)
