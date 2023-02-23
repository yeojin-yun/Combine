//
//  PostViewModel.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/22.
//

import UIKit
import Combine

class PostViewModel {
    
    @Published var post: [Post] = []
    var cancellable = Set<AnyCancellable>()
    
    func requestData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("Invalide URL")
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .assign(to: \.post, on: self)
            .store(in: &self.cancellable)
//            .eraseToAnyPublisher()
    }
}
