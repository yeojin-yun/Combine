//: [Previous](@previous)

import UIKit
let strings = ["a", "1.24", "b", "3.45", "6.7"].publisher
    .compactMap { Float($0) }
    .sink { print($0) }

/*
 1.24
 3.45
 6.7
 */

//: [Next](@next)
