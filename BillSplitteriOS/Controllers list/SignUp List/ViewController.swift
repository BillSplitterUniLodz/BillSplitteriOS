//
//  ViewController.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit

final class ViewController: TemplateController {
    private let backgroundView = UIView(.white, radius: 12)
    private let titleLabel = UILabel(text: "Sign up", ofSize: 24, weight: .bold, color: .black)
    private let stackView = UIStackView()
    private let loginTextField = UICustomTextField(title: "Username", star: true, text: "Severus", placeholder: "Username", height: 60, type: .login)
    private let emailTextField = UICustomTextField(title: "Email", star: true, text: "Severus@gmail.com", placeholder: "Email", height: 60, type: .login)
    private let passwordTextField = UICustomTextField(title: "Password", star: true, text: "123456", placeholder: "Password", height: 60, type: .pass)
    private let changeRegisterModeButton = UIButton()
    private let nextButton = UIButton(backgroundColor: .custom.buttonBackgroundColor, textColor: .white, text: "Next", radius: 12)
    private var signInMode = false
    private var emailTextFieldHeightConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemCyan
        initialize()
    }
    
    private func initialize() {
        backgroundView.shadow()
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, view: backgroundView)
        
        changeRegisterModeButton.setTitle("Already have an account?", for: .normal)
        
        changeRegisterModeButton.addTarget(self, action: #selector(changeRegisterMode), for: .touchUpInside)
        changeRegisterModeButton.setTitleColor(.blue, for: .normal)
        changeRegisterModeButton.titleLabel?.font = .systemFont(ofSize: 16)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        SetupViews.addViewEndRemoveAutoresizingMask(superView: backgroundView, array: [titleLabel, stackView, changeRegisterModeButton, nextButton])
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
            
            nextButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            changeRegisterModeButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
            changeRegisterModeButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            changeRegisterModeButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            changeRegisterModeButton.heightAnchor.constraint(equalToConstant: 16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
        ])
        
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalToConstant: 50)

    }
    
    @objc private func changeRegisterMode() {
        signInMode = !signInMode
        emailTextField.isHidden.toggle()
        if signInMode {
            changeRegisterModeButton.setTitle("Don't have an account?", for: .normal)
            titleLabel.text = "Sign in"
            
        }else {
            changeRegisterModeButton.setTitle("Already have an account?", for: .normal)
            titleLabel.text = "Sign up"
            
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else {return }
            stackView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
            if signInMode {
                stackView.addArrangedSubview(loginTextField)
                stackView.addArrangedSubview(passwordTextField)
            }else {
                stackView.addArrangedSubview(loginTextField)
                stackView.addArrangedSubview(emailTextField)
                stackView.addArrangedSubview(passwordTextField)
            }
            
        }
        
        
    }
    
    @objc private func nextButtonTapped() {
        indicatorView.startAnimating(.auth)
        view.bringSubviewToFront(indicatorView)
        if signInMode {
            Network.shared.signIn(username: loginTextField.text, password: passwordTextField.text) { [weak self] statusCode, token in
                self?.indicatorView.stopAnimating()
                guard let token = token else {
                    self?.alert(title: nil, message: statusCode.message ?? "", url: nil)
                    return
                }
                self?.makeMainController(GroupsViewController())
            }
        }else {
            Network.shared.authorizationAF(username: loginTextField.text, email: emailTextField.text, password: passwordTextField.text) { [weak self] statusCode,token  in
                self?.indicatorView.stopAnimating()
                guard let token = token else {
                    self?.alert(title: nil, message: statusCode.message ?? "", url: nil)
                    return
                }
                self?.makeMainController(GroupsViewController())
            }
        }
    }

}

