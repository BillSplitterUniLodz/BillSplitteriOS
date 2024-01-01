//
//  ViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit

final class ViewController: UIViewController {
    private let backgroundView = UIView(.white, radius: 12)
    private let titleLabel = UILabel(text: "Sign in", ofSize: 24, weight: .bold, color: .black)
    private let loginTextField = UICustomTextField(title: "Username", star: true, text: nil, placeholder: "Username", height: 60, type: .login)
    private let emailTextField = UICustomTextField(title: "Email", star: true, text: nil, placeholder: "Email", height: 60, type: .login)
    private let passwordTextField = UICustomTextField(title: "Password", star: true, text: nil, placeholder: "Password", height: 60, type: .pass)
    private let repeatPasswordTextField = UICustomTextField(title: "Repeat password", star: true, text: nil, placeholder: "Password", height: 60, type: .pass)
    private let nextButton = UIButton(backgroundColor: .custom.buttonBackgroundColor, textColor: .white, text: "Next", radius: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemCyan
        initialize()
    }
    
    private func initialize() {
        backgroundView.shadow()
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: backgroundView)
        repeatPasswordTextField.isHidden = true
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        SetupViews.addViewEndRemoveAutoresizingMask(superView: backgroundView, array: [titleLabel, loginTextField, emailTextField, passwordTextField, repeatPasswordTextField, nextButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            loginTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            emailTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            emailTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            
            passwordTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            
            nextButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
        ])
    }
    
    
    @objc private func nextButtonTapped() {
        
        Network.shared.authorization(username: loginTextField.text, email: emailTextField.text, password: passwordTextField.text) { [weak self] statusCode in
            print(statusCode)
            DispatchQueue.main.async {
                self?.goToNextController()
            }
            
        }
    }
    
    private func goToNextController() {
        let vc = GroupsViewController()
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let navController = UINavigationController(rootViewController: vc)
        keyWindow?.rootViewController = navController
    }

}

