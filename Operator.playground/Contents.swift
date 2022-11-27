import UIKit
import Combine

//
//["1", "2", "3", "4", "5"].publisher.sink {
//    print($0)
//}

["1", "2", "3", "4", "5"].publisher.collect().sink {
    print($0)
}
