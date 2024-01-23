//
//  DebtsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 23/01/2024.
//

import UIKit
class DebtsViewController: TemplateController {
    private lazy var tableView = UITableView()
    private var items = [Owner]()
    
    init(stats: StatsModel) {
        self.items = stats.balance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Who owes to whom"
        initialize()
    }
    
    private func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(DebtTableViewCell.self, forCellReuseIdentifier: "DebtCell")
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DebtsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].payers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCell") as! DebtTableViewCell
        let owner = items[indexPath.section]
        let payer = owner.payers[indexPath.row]
        cell.updateModel(owner: owner.username, debtor: payer.username, amount: payer.amount)
        return cell
    }
}


class DebtTableViewCell: UITableViewCell {
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var amountLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.selectionStyle = .none
        SetupViews.addViewEndRemoveAutoresizingMask(superView: contentView, array: [titleLabel, subtitleLabel, amountLabel])
        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        amountLabel.font = .systemFont(ofSize: 14)
        amountLabel.textColor = .red
        amountLabel.textAlignment = .right
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.widthAnchor.constraint(equalToConstant: 100),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            amountLabel.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: 6),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    func updateModel(owner: String, debtor: String, amount: Int) {
        self.titleLabel.text = "\(debtor) owes to \(owner)"
        let amountInDouble = Double(amount) / 100.0
        self.subtitleLabel.text = "Amount:"
        self.amountLabel.text = "\(amountInDouble)$"
    }
}
