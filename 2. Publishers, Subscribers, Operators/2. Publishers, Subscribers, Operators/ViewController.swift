//
//  ViewController.swift
//  2. Publishers, Subscribers, Operators
//
//  Created by 순진이 on 2022/09/05.
//

import UIKit
import Combine

enum MyError: Error {
    case subscriberError
}

class StringSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        print("--Received Subscription")
        subscription.request(.max(2)) // backpressure - 3개의 결과만 받겠다! 네가 가진 게 100개라도 난 3개만 필요해
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("--Recived Value: ", input)
        
        return .none
        // 위의 메서드에서 request했던 걸 바꿀 수 있음
        // .none : Demand 안 바꿀게 그대로 할거야
        // .unlimited : 네가 가진 것 전부 받을 게
        // .max : 위에서 request했던 것 외에 몇개 더 받을 게
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("--Completed")
    }
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subject : Publisher, Subscribers
        let publisher = ["1", "2", "3", "4", "5"].publisher
        let subscriber = StringSubscriber() // 나는 구독자
        let subject = PassthroughSubject<String, MyError>()
        
//        subject.subscribe(subscriber)
        let subs = subject.sink { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { value in
            print(value)
        }
        
        subject.send("시작")
    }
}

