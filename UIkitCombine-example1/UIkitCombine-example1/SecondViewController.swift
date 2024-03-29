//
//  SecondViewController.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/09.
//

import UIKit
import Combine

final class ViewModel {
    @Published var isSubmitAllowed: Bool = false
}

class SecondViewController: UIViewController {
    
    var switchSubscriber: AnyCancellable?
    var viewModel: ViewModel = ViewModel()
    
    var boolLabel: UILabel = UILabel()
    let acceptSwitch: UISwitch = UISwitch()
    let submitButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        
        switchSubscriber = viewModel.$isSubmitAllowed
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: submitButton)
    }
}

extension SecondViewController {
    @objc func switchTapped(_ sender: UISwitch) {
        viewModel.isSubmitAllowed = sender.isOn
        boolLabel.text = String(viewModel.isSubmitAllowed)
        print(viewModel.isSubmitAllowed)
    }
}

extension SecondViewController {
    func setUI() {
        setAttributes()
        setConstraint()
        addTarget()
    }
    
    func setAttributes() {
        view.backgroundColor = .white
        submitButton.setTitle("submit", for: .normal)
        submitButton.backgroundColor = .blue
        submitButton.setTitleColor(.white, for: .normal)
        boolLabel.text = "switch 값"
    }
    
    func setConstraint() {
        [acceptSwitch, submitButton, boolLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            boolLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boolLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            acceptSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acceptSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
        ])
    }
    
    func addTarget() {
        acceptSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
    }
}
