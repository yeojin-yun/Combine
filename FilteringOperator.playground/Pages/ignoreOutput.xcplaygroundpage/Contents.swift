import UIKit
import Combine


let numbers = (1...5000).publisher
numbers.ignoreOutput().sink {
    print("revciveCompletion", $0)
} receiveValue: {
    print("receiveValue", $0)
}

//revciveCompletion finished


