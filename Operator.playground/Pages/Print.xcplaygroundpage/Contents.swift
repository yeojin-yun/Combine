//: [Previous](@previous)

import Foundation
import Combine

let publisher = (1...3).publisher
publisher
    .print("Debugging")
    .sink {
    print($0)
}

//: [Next](@next)
