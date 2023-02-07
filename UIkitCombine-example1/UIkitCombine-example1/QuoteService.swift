//
//  QuoteService.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/07.
//

import Foundation
import Combine

protocol DataService {
    func getRandomData() -> AnyPublisher<QuoteModel, Error>
}

class QuoteService: DataService {
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func getRandomData() -> AnyPublisher<QuoteModel, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError.badURL as! Error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: QuoteModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
