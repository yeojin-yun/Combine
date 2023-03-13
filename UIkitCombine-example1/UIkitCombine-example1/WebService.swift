//
//  WebService.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/03/13.
//

import Foundation
import Combine

class WebService {
    func getPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("Invalide URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {
                print("❣️\($0.data)")
                return $0.data
                
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
