//
//  TransactionCell.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit

class TransactionCell: UITableViewCell {
    private let amountLabel = UILabel()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        SetupViews.addViewEndRemoveAutoresizingMask(superView: contentView, array: [amountLabel, nameLabel])
        amountLabel.textAlignment = .right
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            
            amountLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func updateModel(transaction: TransactionModel) {
        amountLabel.text = "\(transaction.amount)"
        nameLabel.text = transaction.name
    }
}
