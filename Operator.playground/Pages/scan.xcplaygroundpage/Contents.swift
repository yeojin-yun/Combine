//: [Previous](@previous)

import Foundation
import Combine

let publisher = (1...3).publisher

publisher.scan([1, 2]) { numbers, value -> [Int] in
    //initial Array = []
    numbers + [value]
}.sink {
    print($0)
}

//: [Next](@next)
