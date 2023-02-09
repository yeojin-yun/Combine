//
//  MainViewController.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/09.
//

import UIKit

class MainViewController: UIViewController {
    
    let firstButton: UIButton = UIButton()
    let secondButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension MainViewController {
    @objc func firstBtnTapped(_ sender: UIButton) {
        let vc = FirstViewController()
//        vc.modalPresentationStyle = .
        self.present(vc, animated: true)
    }
    
    @objc func secondBtnTapped(_ sender: UIButton) {
        let vc = SecondViewController()
        self.present(vc, animated: true)
    }
}


extension MainViewController {
    func setUI() {
        setAttributes()
        setConstraints()
        setAddTarget()
    }
    
    func setAttributes() {
        firstButton.setTitle("sample1", for: .normal)
        firstButton.backgroundColor = .blue
        firstButton.setTitleColor(.white, for: .normal)
        
        secondButton.setTitle("sample2", for: .normal)
        secondButton.backgroundColor = .blue
        secondButton.setTitleColor(.white, for: .normal)
    }
    
    func setConstraints() {
        [firstButton, secondButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
        ])
    }
    
    func setAddTarget() {
        firstButton.addTarget(self, action: #selector(firstBtnTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondBtnTapped(_:)), for: .touchUpInside)
    }
}
