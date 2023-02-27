# Combine
Combine study
#### 출처 : https://www.udemy.com/course/the-complete-guide-to-combine-framework-in-ios-using-swift/

## Section2. Publishers, Subscribers and Operators
### 8강 - Hello Publishers and Subscribers
- Notificationcenter
```swift
let notification = Notification.Name("MyNotification")

let center = NotificationCenter.default

//Observer
let observer = center.addObserver(forName: notification, object: nil, queue: nil) { notification in
    print("Notification recevied!")
}

//post
center.post(name: notification, object: nil)

center.removeObserver(observer)
```
- 결과
```swift
Notification recevied!
```
---
### 9강 - Sending Notifications Using Publisher and Subscriber
- Publisher와 Subscriber를 이용하여 동일하게 Notificationcenter 만들기
```swift
let notification = Notification.Name("MyNotification")

let publisher = NotificationCenter.default.publisher(for: notification, object: nil)

// 구독을 하고
let subscription = publisher.sink { _ in
    print("Notification received!")
}

// post를 해야 결과를 받을 수 있음
NotificationCenter.default.post(name: notification, object: nil)
```
- 결과
```swift
Notification recevied!
```
---
### 10강 - Understanding Cancellable
- sink를 이용했을 때 cancel하는 방법은?
- cancel을 해야 메모리 누수, 메모리 낭비가 없음
```swift
let notification = Notification.Name("MyNotification")

let publisher = NotificationCenter.default.publisher(for: notification, object: nil)

// 구독을 하고
let subscription = publisher.sink { _ in
    print("Notification received!")
}

// post를 해야 결과를 받을 수 있음
NotificationCenter.default.post(name: notification, object: nil)

subscription.cancel()
```
- 만약, 아래와 같이 post -> cancel -> post를 하게 된다면?
```swift
let notification = Notification.Name("MyNotification")

let publisher = NotificationCenter.default.publisher(for: notification, object: nil)

// 구독을 하고
let subscription = publisher.sink { _ in
    print("Notification received!")
}

// post를 해야 결과를 받을 수 있음
NotificationCenter.default.post(name: notification, object: nil) //1번 post

subscription.cancel() //1번 post 취소

NotificationCenter.default.post(name: notification, object: nil) //2번 post
```
- 아직 2번 post는 cancel이 되지 않았기 때문에 2번 post에 대한 sink가 살아있음
- subscription은 scope에 영향을 받기 때문에 subscription이 선언된 해당 스코프가 종료되면 자동으로 cancel됨.
---
### 11강 - Implementing a Subscriber
```swift

import UIKit
import Combine

class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never // 실패 가능성 없음
    
    func receive(subscription: Subscription) {
        print("Received Subscription")
        subscription.request(.max(3)) // backpressure - 3개의 결과만 받겠다! 네가 가진 게 100개라도 난 3개만 필요해
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Recived Value: ", input)
        return .max(3)
        // 위의 메서드에서 request했던 걸 바꿀 수 있음

    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let publisher = ["1", "2", "3", "4", "5", "6", "7", "8"].publisher
        
        //how to use
        let subscriber = StringSubscriber()
        
        publisher.subscribe(subscriber)
    }
}
```
- 결과
```swift
Received Subscription
Recived Value:  1
Recived Value:  2
Recived Value:  3
```
- `func receive(_ input: String) -> Subscribers.Demand `
    - .none : Demand 안 바꿀게 그대로 할거야
    ```swift 
    Received Subscription
    Recived Value:  1
    Recived Value:  2
    Recived Value:  3
    ```
    - .unlimited : 네가 가진 것 전부 받을 게
    ```swift
    Received Subscription
    Recived Value:  1
    Recived Value:  2
    Recived Value:  3
    Recived Value:  4
    Recived Value:  5
    Recived Value:  6
    Recived Value:  7
    Recived Value:  8
    Completed
    ```
    - .max : 위에서 request했던 것 외에 몇개 더 받을 게 (두 번째 demand에서 max(5)로 바꿨을 때)
    ```swift
    Received Subscription
    Recived Value:  1
    Recived Value:  2
    Recived Value:  3
    Recived Value:  4
    Recived Value:  5
    Recived Value:  6
    Recived Value:  7
    Recived Value:  8
    Completed
    ```
- publisher를 전부 구독해야 `func receive(completion: Subscribers.Completion<Never>)`가 발생되는 것 같음
---
### 12강 - Subjects
```swift

import UIKit
import Combine

enum MyError: Error {
    case subscriberError
}

class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never // 실패 가능성 없음
    
    func receive(subscription: Subscription) {
        print("Received Subscription")
        subscription.request(.max(3)) // backpressure - 3개의 결과만 받겠다! 네가 가진 게 100개라도 난 3개만 필요해
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Recived Value: ", input)
        return .max(3)
        // 위의 메서드에서 request했던 걸 바꿀 수 있음

    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscriber = StringSubscriber() // 나는 구독자
        let subject = PassthroughSubject<String, MyError>()
        

        subject.subscribe(subscriber)
        let subscription = subject.sink { (completion) in
            print("🍏 Received Completion from sink")
        } receiveValue: { (string) in
            print("🍎 Received \(string) from sink")
        }

        
        subject.send("A")
        subject.send("1")
        subject.send("B")
        subject.send("2")
        subject.send("C")
        subject.send("3")

    }
}
```
- 결과
```
--Received Subscription
--Recived Value:  A
🍎 Received A from sink
🍎 Received 1 from sink
🍎 Received B from sink
🍎 Received 2 from sink
🍎 Received C from sink
🍎 Received 3 from sink
```
---
## Section3. Transforming Operators
### 15강 - Collect
- 개별 요소들을 배열로 모아줌
```swift
["1", "2", "3", "4", "5"].publisher.sink {
    print($0)
    //1
    //2
    //3
    //4
    //5
}
```
- `collect()` 사용했을 때
```swift
["1", "2", "3", "4", "5"].publisher.collect().sink {
    print($0)
    //["1", "2", "3", "4", "5"]
}
```
### 16강 - map
```swift
let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .spellOut

[123, 45, 67].publisher.map {
    numberFormatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
}.sink {
    print($0)
}
```
- 결과
```swift
one hundred twenty-three
forty-five
sixty-seven
```

### 17강 - map KeyPath
```swift
struct Point {
    let x: Int
    let y: Int
}

let publisher = PassthroughSubject<Point, Never>()

publisher.map(\.x, \.y).sink { x, y in
    print("x is \(x) and y is \(y)")
}

publisher.send(Point(x: 2, y: 10))

```
- 결과
```
x is 2 and y is 10
```
### 18강 - flatMap
```swift
struct School {
    let name: String
    let numberOfStudents: CurrentValueSubject<Int, Never>
    
    init(name: String, numberOfStudents: Int) {
        self.name = name
        self.numberOfStudents = CurrentValueSubject(numberOfStudents)
    }
}

let citySchool = School(name: "citySchool", numberOfStudents: 10)

let publisher = CurrentValueSubject<School, Never>(citySchool)

publisher
    .flatMap { $0.numberOfStudents }
    .sink { print("results: ", $0) }


let townSchool = School(name: "타운스쿨", numberOfStudents: 50)
//results:  10

publisher.value = townSchool
//results:  10
//results:  50

citySchool.numberOfStudents.value += 1
//results:  10
//results:  50
//results:  11

townSchool.numberOfStudents.value -= 3
//results:  10
//results:  50
//results:  11
//results:  47
```
- flatMap은 사용자가 지정하는 최대 갯수까지 업스트림 publisher의 모든 요소를 새 publisher로 변환
- 그래서 citySchool과 townSchool의 numberOfStudents 값만 바꿔도 앞에 값 바꾸기 전 요소들도 전부 버퍼링됨

- 만약에 max 값을 정해준다면?
```swift
publisher
    .flatMap(maxPublishers: .max(2), {
        $0.numberOfStudents
    })
    .sink { print("results: ", $0) }



let townSchool = School(name: "타운스쿨", numberOfStudents: 50)
//results:  10

publisher.value = townSchool
//results:  10
//results:  50

citySchool.numberOfStudents.value += 1
//results:  10
//results:  50
//results:  11

townSchool.numberOfStudents.value -= 3
//results:  10
//results:  50
//results:  11
//results:  47
```



### 19강 - replaceNil
```swift
["A", "B", nil, "C"].publisher.replaceNil(with: "⭐️")
    .sink { print($0) }
```

- 결과
```
Optional("A")
Optional("B")
Optional("⭐️")
Optional("C")
```

- Optional 바인딩을 원할 때는?
```swift
["A", "B", nil, "C"].publisher.replaceNil(with: "⭐️")
    .map { $0! }
    .sink { print($0) }
```
- Optional Binding 결과
```
A
B
⭐️
C
```

### 20강 - replaceEmpty
```swift
let empty = Empty<Int, Never>()
empty
    .sink(receiveCompletion: { completion in
    print("completion is \(completion)")
    
}, receiveValue: { result in
    print("results is \(result)")
})
```

- 결과
```
completion is finished
```

- replaceEmpty 사용
```swift
let empty = Empty<Int, Never>()
empty
    //.replaceEmpty(with: 1)
    .sink(receiveCompletion: { completion in
    print("completion is \(completion)")
    
}, receiveValue: { result in
    print("results is \(result)")
})
```

- replaceEmpty 사용 결과
```
results is 1
completion is finished
```

### 21강 - scan
- scan의 첫 번째 파라미터 initialResult
- scan의 두 번째 파라미터 nextPartialResult
- initialResult에 upstream 발행자로부터 emit된 요소를 인자로 받음 
```swift
let publisher = (1...3).publisher

publisher.scan([1]) { numbers, value -> [Int] in
    //initial Array = [1]
    numbers + [value]
}.sink {
    print($0)
}
```
- 결과
```
[1, 1]
[1, 1, 2]
[1, 1, 2, 3]
```

- initial Array를 [1, 2]로 설정했을 때 코드와 결과
```swift
let publisher = (1...3).publisher

publisher.scan([1, 2]) { numbers, value -> [Int] in
    //initial Array = []
    numbers + [value]
}.sink {
    print($0)
}
```
```
[1, 2, 1]
[1, 2, 1, 2]
[1, 2, 1, 2, 3]

```
---
### 24강 - filter
```swift
let numbers = (1...8).publisher

numbers.filter { $0 % 2 == 0 }
    .sink { print("filtering value is",$0)}
```
- 결과
```
filtering value is 2
filtering value is 4
filtering value is 6
filtering value is 8

```

### 25강 - removeDuplicates
- 중복되는 요소가 모두 제거되어(removeDuplicates) 하나의 결과만 나옴
```swift
let words = "apple apple fruit fruit mango mango watermelon watermelon".components(separatedBy: " ").publisher

words
    .removeDuplicates()
    .sink { print($0) }
```
- 결과
```
apple
fruit
mango
watermelon
```
### 26강 - CompactMap
```swift
let strings = ["a", "1.24", "b", "3.45", "6.7"].publisher
    .compactMap { Float($0) }
    .sink { print($0) }
```

- 결과
```
 1.24
 3.45
 6.7
```
### 27강 - ignoreOutput
    모든 업스트림 요소를 무시하지만 업스트림 게시자의 완료 상태(완료 또는 실패)는 전달

```swift
let numbers = (1...5000).publisher
numbers.ignoreOutput().sink {
    print("revciveCompletion", $0)
} receiveValue: {
    print("receiveValue", $0)
}
```
- 결과
```
revciveCompletion finished
```

### 28강 - first
    스트림의 첫 번째 요소만 publish하고 끝냄  
```swift
let numbers = (1...9).publisher

numbers.first(where: { $0 % 2 == 0 })
    .sink { print($0) }
```

- 결과
```
2
```

### 29강 - last
    스트림의 마지막 요소만 publish하고 끝냄  
```swift
let numbers = (1...9).publisher

numbers.last(where: { $0 % 2 == 0 })
    .sink { print($0) }
```

- 결과
```
8
```

### 30강 - dropFirst
```swift
let numbers = (1...10).publisher

numbers.dropFirst(8)
    .sink { print($0) }
```

- 결과
```
//9, 10
```

### 31강 - dropWhile
`while` 클로저의 값이 false를 return할 때까지 elements를 방출
```swift
let numbers = (1...10).publisher

numbers.drop(while: { $0 % 3 != 0 })
    .sink { print($0) }

```
- 결과
```
3
4
5
6
7
8
9
10

```
### 50강 - URLSession Extension
```swift
import UIKit
import Combine

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCombine()
    }
    
    func getPosts() -> AnyPublisher<Data, URLError> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError("Invalide URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    func testCombine() {
        let cancellable = getPosts().sink(receiveCompletion: { _ in }) { data in
            print(data)
        }
    }
}

```
---
### 53강 - Printing events
```swift
let publisher = (1...20).publisher
publisher
    .print("Debugging")
    .sink {
    print($0)
}

```
- 결과
```swift
Debugging: receive subscription: (1...3)
Debugging: request unlimited
Debugging: receive value: (1)
1
Debugging: receive value: (2)
2
Debugging: receive value: (3)
3
Debugging: receive finished
```
---
## combine의 주요 요소

### `protocol` : Publisher

- Publisher transmits values that can change over time
- 시간이 지남에 따라 변경될 수 있는 값을 전송
- Output과 Failure라는 두 가지의 associated type을 가짐
- 모든 publisher들은 다양한 이벤트들을 방출할 수 있음
    - Output type의 output
    - 성공적인 completion
    - Failure type의 에러를 가진 실패

### `protocol` : Subscriber

- Subscriber receives those values from the publisher
- 구독자는 publisher로부터 그 값들을 받음
- publisher와 operators는 published된 이벤트들을 수신하지 않는 한 의지가 없음 → 구독자가 있어야 함
- Input과 Failure라는 두 가지의 associated type을 가짐
    - 구독자는 publisher로부터 값의 스트림 또는 이벤트의 완료/실패를 받음

### Subscription

- Subscription represents the connection of a subscriber to a publisher
- subscriber와 publisher의 연결을 나타냄

### Operator

- publisher를 호출하여 publisher와 같거나 다른 publisher를 return하는 연산자
- 값을 변경하거나, 값을 추가하거나, 값을 제거하거나, 기타 많은 작업을 수행할 수 있음

---
