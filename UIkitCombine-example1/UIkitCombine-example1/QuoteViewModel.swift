//
//  QuoteViewModel.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/06.
//

import Foundation
import Combine

enum Input {
    case viewDidAppear
    case refreshButtonDidTap
}

enum Output {
    case fetchQuoteDidFail(error: Error)
    case fetchQuoteDidSuccess(quote: QuoteModel)
    case toggleButton(isEnabled: Bool)
}

class QuoteViewModel {
    private let dataService: DataService
    
    private let output1: PassthroughSubject<Output, Never> = .init()
//    private let output2: CurrentValueSubject<Output, Never> = .init(.toggleButton(isEnabled: true))
    private var cancelables = Set<AnyCancellable>()
    
    init(dataService: DataService = QuoteService(urlString: "https://api.quotable.io/random")) {
        self.dataService = dataService
    }
    
    //4
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        print(#function)
        input
            .sink { [weak self] receivedValue in
                switch receivedValue {
                case .refreshButtonDidTap, .viewDidAppear:
                    self?.handleGetRandomQuote()
                }
            }
            .store(in: &cancelables)
        return output1.eraseToAnyPublisher()
    }
    
    //5
    func handleGetRandomQuote() {
        print(#function)
        output1.send(.toggleButton(isEnabled: false))
        dataService.getRandomData()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] completion in
                self?.output1.send(.toggleButton(isEnabled: true))
                switch completion {
                case .failure(let error):
                    self?.output1.send(.fetchQuoteDidFail(error: error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] receivedValue in
                self?.output1.send(.fetchQuoteDidSuccess(quote: receivedValue))
            }
            .store(in: &cancelables)
    }
}
