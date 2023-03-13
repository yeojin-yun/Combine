//
//  ThirdViewController.swift
//  UIkitCombine-example1
//
//  Created by 순진이 on 2023/02/14.

// a single view with a button in the middle and the button background color changes with the button action. 

import UIKit
import Combine

struct Post: Codable {
    let title: String
    let body: String
}

class ThirdViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        

    }

}
