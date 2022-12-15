//: [Previous](@previous)

import Foundation
import Combine

let words = "apple apple fruit fruit mango mango watermelon watermelon".components(separatedBy: " ").publisher

words
    .removeDuplicates()
    .sink { print($0) }
// 중복되는 요소가 모두 제거되어(removeDuplicates) 하나의 결과만 나옴

/*
apple
fruit
mango
watermelon
*/

//: [Next](@next)
