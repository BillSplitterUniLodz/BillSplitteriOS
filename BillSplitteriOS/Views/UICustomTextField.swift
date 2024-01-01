//
//  UICustomTextField.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
enum FilterStatus {
    case open
    case closed
}
enum TypeMenu {
    case login
    case pass
    case button
    
    var string: String {
        switch self {
        case .login: return "Login"
        case .pass: return "Password"
        case .button: return "Choose"
        }
    }
}
@objc protocol UICustomTextFieldDelegate: AnyObject {
    @objc optional func customTextField(_ customTextField:UICustomTextField, changed text: String?)
    @objc optional  func customTextField(_ customTextField:UICustomTextField, didBegin text: String?)
    @objc optional  func customTextField(_ customTextField:UICustomTextField, doneButton text: String?)
    @objc optional  func customTextField(_ customTextField:UICustomTextField, endEditing text: String?)
}
class UICustomTextField: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    weak var delegate: UICustomTextFieldDelegate?
    private lazy var view = UIView(.lightGray)
    private lazy var typeLabel: UILabel = UILabel(text: "", ofSize: 10, weight: .regular, color: .custom.gray)
    private lazy var starLabel: UILabel = UILabel(text: "*", ofSize: 10, weight: .regular, color: .custom.red)
    private lazy var errorLabel: UILabel = UILabel(text: "", ofSize: 12, weight: .regular, color: .custom.red)
    let button: UIButton = UIButton(backgroundColor: .clear, textColor: .black, text: "")
    private lazy var textField:UITextField! = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.backgroundColor =  .clear
        textField.placeholderColor = .custom.gray3
        textField.indent(size: 16)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.addToolBar(self, action: #selector(doneAction), title: "Готово")
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        textField.delegate = self
        return textField
    }()
    
    var type: TypeMenu = .login
    
    var didSelectCalendar: (() -> ())?
    
    var isOnPlacholderAnimation: Bool = false {
        willSet {
            let string = textField.text ?? ""
            if newValue {
                typeLabel.isHidden = string.isEmpty
                starLabel.isHidden = string.isEmpty
            } else {
                typeLabel.isHidden = false
                starLabel.isHidden = false
            }
        }
    }
    
    var hasCalendarImageView: Bool = false
    var isSecureTextField: Bool = false {
        willSet {
            if newValue {
                textField.isSecureTextEntry = true
            } else {
                textField.isSecureTextEntry = false
            }
        }
    }
    
    var borderColor: UIColor? = nil {
        willSet {
            guard let newValue = newValue else {self.view.layer.borderWidth = 0; return}
            view.layer.borderColor = newValue.cgColor
            view.layer.borderWidth = 1
        }
    }
    
    private lazy var imagViewEye:UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "eye"))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var statusPasswordText:FilterStatus = .closed {
        didSet {
            if type != .pass {return}
            textField.isSecureTextEntry = statusPasswordText == .closed
            imagViewEye.image = statusPasswordText == .closed ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        }
    }
    
    convenience init(title: String, star:Bool, text: String?, placeholder: String?, height: CGFloat = 44.0, type: TypeMenu = .login, hasCalendar: Bool = false) {
        self.init(frame: .zero)
        self.type = type
        
        self.typeLabel.text = title
        self.textField.placeholder = placeholder
        self.textField.text = text
        textField.contentVerticalAlignment = .center
        textField.contentMode = .center
        self.starLabel.isHidden = !star
        if star { typeLabel.text = title + "*" }
        self.hasCalendarImageView = hasCalendar
        setupView(height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        textField.autocapitalizationType = .words
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ height: CGFloat = 44.0) {
        self.backgroundColor = .clear
        view.layer.borderColor = UIColor.custom.blue.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        let errorViewLabel = UIView(.clear)
        errorViewLabel.addSubview(errorLabel)
        errorLabel.fullConstraint(top: 0, bottom: 0, leading: 16, trailing: -16)
        
        let stackView = UIStackView(.vertical, .fill, .fill, 8, [UIView(), typeLabel, view, errorViewLabel])
        errorViewLabel.isHidden = true
        SetupViews.addViewEndRemoveAutoresizingMask(superView: view, array: [textField, button])
        self.addSubview(stackView)
        stackView.fullConstraint()
        errorLabel.numberOfLines = 0
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = UIColor.custom.subtitleColor
        
        button.showsMenuAsPrimaryAction = true
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44.0),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12),
            typeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
//            typeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
//            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            typeLabel.heightAnchor.constraint(equalToConstant: 18),
//
//            starLabel.topAnchor.constraint(equalTo: typeLabel.topAnchor),
//            starLabel.bottomAnchor.constraint(equalTo: typeLabel.bottomAnchor),
//            starLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor),
//            starLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        if type == .pass {
            textField.isSecureTextEntry = true
            let view = UIView(.clear)
            view.addSubview(imagViewEye)
            let tap = UITapGestureRecognizer(target: self, action: #selector(actionEye))
            tap.delegate = self
            view.addGestureRecognizer(tap)
            view.translatesAutoresizingMaskIntoConstraints = false
            imagViewEye.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4),
                view.widthAnchor.constraint(equalToConstant: 32),
                
                imagViewEye.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
                imagViewEye.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
                imagViewEye.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
                imagViewEye.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
                
            ])
        }
        
        if hasCalendarImageView {
            let view = UIView(.clear)
            view.addSubview(calendarImageView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(calendarAction))
            tap.delegate = self
            view.addGestureRecognizer(tap)
            view.translatesAutoresizingMaskIntoConstraints = false
            calendarImageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4),
                view.widthAnchor.constraint(equalToConstant: 32),
                
                calendarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
                calendarImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
                calendarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
                calendarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
                
            ])
        }
        
        if type == .button {
            button.fullConstraint(leading: 16)
        }
    }
    
    internal func textFieldDidChangeSelection(_ textField: UITextField) {
        let string = textField.text ?? ""
        if isOnPlacholderAnimation {
            typeLabel.isHidden = string.isEmpty
            starLabel.isHidden = string.isEmpty
        }
    }
    
    @objc private func actionEye() {
        statusPasswordText = statusPasswordText == .open ? .closed : .open
    }
    
    @objc private func calendarAction() {
        didSelectCalendar?()
    }
    
    func updateButtonMenu(menu: UIMenu) {
        self.button.menu = menu
    }
}

//MARK: - Публичные переменные
extension UICustomTextField {
    
    var contentVerticalAlignment: UIControl.ContentVerticalAlignment {get {textField.contentVerticalAlignment} set {textField.contentVerticalAlignment = newValue}}
    var keyboardType: UIKeyboardType {get {textField.keyboardType} set {textField.keyboardType = newValue}}
    var isEmpty: Bool {textField.text?.isEmpty ?? true}
    var star:Bool {get{!(starLabel.text ?? "").isEmpty} set {starLabel.text = newValue ? "*" : ""}}
    //текст над текстовым полем
    var title: String? {get {return typeLabel.text}set {typeLabel.text = newValue}}
    var placeholder: String? {get {return textField.placeholder}set {textField.placeholder = newValue}}
    var text: String {get {return textField.text ?? ""}set {textField.text = newValue}}
    var font: UIFont? {get {return textField.font}set {textField.font = newValue}}
    var infomationLabelFont: UIFont {get {return typeLabel.font}set {typeLabel.font = newValue}}
    var isHiddenInfomationLabel: Bool{ get {typeLabel.isHidden} set {typeLabel.isHidden = newValue} }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    
    //текст ошибки
    var errorString: String {
        get { errorLabel.text ?? "" }
        set {
            errorLabel.text = newValue
        }
    }
    
    var isOnError: Bool {
        get { !errorLabel.superview!.isHidden }
        set {
            errorLabel.superview!.isHidden = !newValue
        }
    }
}


//MARK: - Публичные методы
extension UICustomTextField {
    //нажатие кнопки ГОТОВО
    @objc private func doneAction() {
        delegate?.customTextField?(self, doneButton: textField.text)
        self.superview?.endEditing(true) }
    
    //редактирование текстового поля
    @objc func textFieldChanged(_ textField:UITextField) {
        delegate?.customTextField?(self, changed: textField.text)
    }
    
    //наведение на поле редактирования
    @objc func editingDidBegin(_ textField:UITextField) {
        delegate?.customTextField?(self, didBegin: textField.text)
    }
    
    //конец редактирования
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.customTextField?(self, endEditing: textField.text)
    }
}
