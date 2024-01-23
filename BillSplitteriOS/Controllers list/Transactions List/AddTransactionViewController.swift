//
//  AddTransactionViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 23/01/2024.
//

import UIKit
final class AddTransactionViewController: TemplateController {
    private lazy var transactionNameTextField = UICustomTextField(title: "Transaction name", star: true, text: nil, placeholder: "Name your transaction", height: 60)
    private lazy var amountTextField = UICustomTextField(title: "Enter amount in cents", star: true, text: nil, placeholder: "1000 = 10$", height: 60)
    private lazy var addButton = UIButton()
    private lazy var titleLabel = UILabel(text: "Create Transaction", font: .boldSystemFont(ofSize: 24))
    
    var onAddAction: ((ExpenseModel, String) -> ())?
    
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
        
        initialize()
    }
    
    private func initialize() {
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, array: [titleLabel,transactionNameTextField, amountTextField, addButton])
        amountTextField.keyboardType = .numberPad
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .systemTeal
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.layer.cornerRadius = 12
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            transactionNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            transactionNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            transactionNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            amountTextField.topAnchor.constraint(equalTo: transactionNameTextField.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func addButtonTapped() {
        let name = transactionNameTextField.text
        let amount = amountTextField.text
        let amountInt = Int(amount) ?? 0
        if !name.isEmpty, !amount.isEmpty {
            Network.shared.createTransaction(for: group.uuid, name: name, amount: amountInt) { [weak self] statusCode, expense in
                guard let self else { return }
                guard let expense else {
                    self.alert(error: statusCode, action: nil)
                    return
                }
                self.dismiss(animated: true) { [weak self] in
                    guard let newSelf = self else { return }
                    let owner = AuthApp.shared.autorization
                    newSelf.onAddAction?(expense, owner?.username ?? "")
                }
            }
        }else {
            alert(title: nil, message: "Fill all the fields", url: nil)
        }
        
    }
}
