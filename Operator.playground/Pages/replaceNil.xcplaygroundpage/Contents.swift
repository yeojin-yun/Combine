//: [Previous](@previous)

import Foundation
import Combine

["A", "B", nil, "C"].publisher.replaceNil(with: "⭐️")
    .map { $0! }
    .sink { print($0) }

//: [Next](@next)
