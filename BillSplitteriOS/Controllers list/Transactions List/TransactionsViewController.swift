//
//  TransactionsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
final class TransactionsViewController: UIViewController {
    private let tableView = UITableView()
    private var items = [
        TransactionModel(id: UUID(), amount: 100.0, name: "Groceries", participants: []),
        TransactionModel(id: UUID(), amount: 236.79, name: "Hostel", participants: [])
    ]
    private let group: GroupModel
    
    init(group: GroupModel) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = group.name
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        initialize()
    }
    
    private func initialize() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBarButtonAction))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 60
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func plusBarButtonAction() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        self.present(vc, animated: true)
    }
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TransactionCell
        cell?.updateModel(transaction: items[indexPath.row])
        return cell ?? .init()
    }
    
}
