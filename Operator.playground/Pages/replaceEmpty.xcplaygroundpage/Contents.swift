//: [Previous](@previous)

import Foundation
import Combine

let empty = Empty<Int, Never>()
empty
    .replaceEmpty(with: 1)
    .sink(receiveCompletion: { completion in
    print("completion is \(completion)")
    
}, receiveValue: { result in
    print("results is \(result)")
})

//: [Next](@next)

//sometimes you don't want to pass the value. you just want to say that I'm done or this task has been completed without passing the value.
