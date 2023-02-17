//
//  ThirdViewController.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/14.

// a single view with a button in the middle and the button background color changes with the button action. 

import UIKit
import Combine

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancellable = getPosts().sink(receiveCompletion: { _ in }) { data in
            print(data)
        }
        
    }
    
    func getPosts() -> AnyPublisher<Data, URLError> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { fatalError("Invalide URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }

}
