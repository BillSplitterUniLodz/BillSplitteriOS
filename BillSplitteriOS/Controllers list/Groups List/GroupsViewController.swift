//
//  RoomsViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
final class GroupsViewController: TemplateController {
    private lazy var tableView = UITableView()
    private var items = [GroupModel]()
    private let logoutButton = UIButton()
    private let joinButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        initialize()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        indicatorView.startAnimating(.update)
        view.bringSubviewToFront(indicatorView)
        Network.shared.getGroups { [weak self] statusCode, groups in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            if let groups = groups {
                DispatchQueue.main.async {
                    self.items = groups
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func initialize() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusBarButtonAction))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.rowHeight = 50
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: tableView)
        
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.layer.cornerRadius = 12
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.red.cgColor
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        joinButton.setTitle("Join", for: .normal)
        joinButton.backgroundColor = .systemTeal
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 12
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, array: [logoutButton, joinButton])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            joinButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            joinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            joinButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -8)
        ])
    }
    
    @objc private func logoutButtonTapped() {
        AuthApp.shared.removeToken()
        makeMainController(ViewController())
    }
    
    @objc private func joinButtonTapped() {
        createAlertWithTextField(title: "Enter token to join the group", buttonName: "Join") { [weak self] groupToken in
            guard let self else { return }
            indicatorView.startAnimating(.update)
            view.bringSubviewToFront(indicatorView)
            Network.shared.joinGroup(token: groupToken) { [weak self] statusCode, joinedGroup in
                guard let self else { return }
                self.indicatorView.stopAnimating()
                if let group = joinedGroup {
                    DispatchQueue.main.async {
                        self.items.append(group)
                        self.tableView.reloadData()
                    }
                }else {
                    self.alert(error: statusCode, action: nil)
                }
            }
        }
    }
    
    @objc private func plusBarButtonAction() {
        createAlertWithTextField(title: "Add a new group", buttonName: "Add") { [weak self] name in
            guard let self else { return }
            Network.shared.createGroup(name: name) { [weak self] statusCode, model  in
                guard let self else {return}
                if let model = model {
                    self.items.append(model)
                }else {
                    self.alert(error: statusCode) { _ in
                        
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
