import UIKit
import Combine

let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .spellOut

[123, 45, 67].publisher.map {
    numberFormatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
}.sink {
    print($0)
}

/*
 one hundred twenty-three
 forty-five
 sixty-seven
 */
