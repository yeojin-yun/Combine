//
//  ViewController.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/06.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private let viewModel = QuoteViewModel()
    private let input: PassthroughSubject<Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    let label: UILabel = UILabel()
    let button: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        input.send(.viewDidAppear)
    }
    
    func bind() {
        print(#function)
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
                switch receivedValue {
                case .fetchQuoteDidFail(error: let error):
                    self?.label.text = error.localizedDescription
                case .fetchQuoteDidSuccess(quote: let data):
                    self?.label.text = data.content
                case .toggleButton(isEnabled: let isEnabled):
                    self?.button.isEnabled = isEnabled
                }
            }
            .store(in: &cancellables)
    }
}

extension ViewController {
    @objc func buttonTapped(_ sender: UIButton) {
        print(#function)
        input.send(.refreshButtonDidTap)
    }
}

extension ViewController {
    func setUI() {
        print(#function)
        setAttributes()
        setConstraints()
    }
    
    func setAttributes() {
        print(#function)
        label.numberOfLines = 0
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .blue
        button.configuration = config
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func setConstraints() {
        print(#function)
        [label, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
