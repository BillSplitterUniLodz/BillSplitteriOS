//
//  RoomsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
final class GroupsViewController: UIViewController {
    private lazy var tableView = UITableView()
    private var items = [GroupModel(id: UUID(), name: "Trip to Wroclaw", participants: [])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rooms"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        initialize()
    }
    
    private func initialize() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBarButtonAction))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.rowHeight = 50
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
        let alert = UIAlertController(title: "Add a new room", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self else { return }
            let name = alert.textFields![0]
            if let name = name.text, !name.isEmpty {
                Network.shared.createGroup(name: name) { [weak self] statusCode, model  in
                    guard let self else {return}
                    if let model = model {
                        self.items.append(model)
                    }else {
                        //TODO:
                        self.items.append(GroupModel(id: UUID(), name: name, participants: []))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.present(alert, animated: true)
    }
    
    
}

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell
        cell?.updateModel(name: items[indexPath.row].name)
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionsViewController(group: items[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
