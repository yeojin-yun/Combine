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
sink
```
