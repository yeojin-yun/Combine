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
    var viewModel = PostViewModel()
    var cancellable = Set<AnyCancellable>()

    let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUI()
        self.viewModel.requestData()
        
        self.viewModel.$post
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &self.cancellable)
    }
}

extension ThirdViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
//        let postCell = PostCellViewModel(title: viewModel.post., body: <#T##String#>)
//        cell.configure(with: <#T##PostCellViewModel#>)
        cell.titleLabel.text = viewModel.post[indexPath.row].title
        cell.bodyLabel.text = viewModel.post[indexPath.row].body
        return cell
    }

}

extension ThirdViewController {
    func setUI() {
        setTableView()
        setConstraints()
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = 100
    }
    
    func setConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
    }
}
