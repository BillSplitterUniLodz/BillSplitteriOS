//
//  TransactionsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
final class TransactionsViewController: TemplateController {
    private let tableView = UITableView()
    private var items = [ExpenseModel]()
    private let calculateButton = UIButton()
    private let inviteButton = UIButton()
    
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
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        Network.shared.getExpenses(for: group.uuid) { [weak self] statusCode, groupExpenses in
            guard let self else { return }
            guard let groupExpenses else {
                self.alert(error: statusCode, action: nil)
                return
            }
            DispatchQueue.main.async {
                self.items = groupExpenses
                self.tableView.reloadData()
            }
        }
    }
    
    private func initialize() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBarButtonAction))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 60
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: tableView)
        
        calculateButton.setTitle("Calculate", for: .normal)
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.backgroundColor = .systemTeal
        calculateButton.layer.cornerRadius = 12
        calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.backgroundColor = .systemTeal
        inviteButton.layer.cornerRadius = 12
        inviteButton.addTarget(self, action: #selector(invite), for: .touchUpInside)
        
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, array: [calculateButton, inviteButton])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            calculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calculateButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            calculateButton.heightAnchor.constraint(equalToConstant: 50),
            
            inviteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            inviteButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            inviteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inviteButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: calculateButton.topAnchor, constant: -8)
        ])
    }
    
    @objc private func calculate() {
        Network.shared.calculate(groupId: group.uuid) { [weak self] statusCode, statsModel in
            guard let self else { return }
            guard let statsModel else {
                self.alert(error: statusCode, action: nil)
                return
            }
            print(statsModel)
            let vc = DebtsViewController(stats: statsModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func invite() {
        Network.shared.generateInviteLink(groupId: group.uuid) { [weak self] statusCode, inviteToken in
            guard let self else {return}
            guard let inviteToken else {
                alert(error: statusCode, action: nil)
                return
            }
            self.creatAlertWithCopyFunction(title: "Token for Invitation", text: inviteToken)
        }
        
    }
    
    @objc private func plusBarButtonAction() {
        let vc = AddTransactionViewController(group: group)
        vc.view.backgroundColor = .systemBackground
        vc.onAddAction = { [weak self] expense, owner in
            guard let self else { return }
            DispatchQueue.main.async {
                self.items.append(expense)
                self.tableView.reloadData()
            }
        }
        self.present(vc, animated: true)
    }
}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TransactionCell
        let model = items[indexPath.row]
        cell?.updateModel(expense: model)
        return cell ?? .init()
    }
    
}
