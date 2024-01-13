//
//  GroupCell.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
class GroupCell: UITableViewCell {
    private lazy var label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        SetupViews.addViewEndRemoveAutoresizingMask(superView: contentView, view: label)
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func updateModel(name: String) {
        label.text = name
    }
    
}
