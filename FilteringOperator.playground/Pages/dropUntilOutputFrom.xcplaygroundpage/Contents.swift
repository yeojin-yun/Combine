//: [Previous](@previous)

import Foundation
import Combine

let isReady = PassthroughSubject<Void, Never>()
let taps = PassthroughSubject<Int, Never>()

taps.drop(untilOutputFrom: isReady).sink {
    print($0)
}

(1...10).forEach { n in
    taps.send(n)
    
    if n == 3 {
        isReady.send()
    }
}

/*
 4
 5
 6
 7
 8
 9
 10
 */

//: [Next](@next)
