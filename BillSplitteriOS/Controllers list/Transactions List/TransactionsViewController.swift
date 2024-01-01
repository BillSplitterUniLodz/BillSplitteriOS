//
//  TransactionsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
final class TransactionsViewController: UIViewController {
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transactions"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func initialize() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBarButtonAction))
        
    }
    
    @objc private func plusBarButtonAction() {
        
    }
}
