//
//  TemplateController.swift
//  BillSplitteriOS
//
//  Created by Temur on 23/01/2024.
//

import UIKit
class TemplateController: UIViewController {
    lazy var indicatorView:UIIndicatorView = UIIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.fullConstraint()
    }
    
    func alert(title:String?, message:String?, url:URL?) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            let alerts = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alerts.addAction(cancel)
            
            if let url = url {
                let setting = UIAlertAction(title: "Settings", style: .default) { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                alerts.addAction(setting)
            }
            self.present(alerts, animated: true, completion: nil)
        }
    }
    
    func alert(error:StatusCode, action: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: action)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
    
    func makeMainController(_ vc: UIViewController) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let navController = UINavigationController(rootViewController: vc)
        keyWindow?.rootViewController = navController
    }
    
    func createAlertWithTextField(title: String, buttonName: String, completion: @escaping (String) -> ()) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: buttonName, style: .default) { _ in
            let name = alert.textFields![0]
            if let name = name.text, !name.isEmpty {
                completion(name)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.present(alert, animated: true)
    }
    
    func creatAlertWithCopyFunction(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) { action in
            UIPasteboard.general.string = text
            action.setValue("Copied", forKey: "title")
        }
        
        
//        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
//        alert.addAction(cancelAction)
        alert.addAction(copyAction)
        self.present(alert, animated: true)
    }
}


class UIIndicatorView: UIView {
    enum InfoText {
        case download
        case update
        case pushData
        case auth
        
        
        var string: String {
            switch self {
                
            case .download:
                return "Downloading data..."
            case .update:
                return "Updating data..."
            case .pushData:
                return "Sending data..."
            case .auth:
                return "Authorization..."
            }
        }
    }

    private let view:UIView
    private let indicator:UIActivityIndicatorView
    private let label:UILabel
    var text:String? = "" {
        willSet {
            label.text = newValue
        }
    }
    
    override init(frame:CGRect) {
        view = UIView(.custom.black)
        view.alpha = 0.1
        indicator = UIActivityIndicatorView()
        label = UILabel(text: "", ofSize: 13, weight: .medium, color: .gray)
        super.init(frame: frame)
        setapView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    private func setapView() {
        label.backgroundColor = .clear
        label.contentMode = .center
        label.textAlignment = .center
        indicator.style = .medium
        indicator.color = .blue
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = .clear
        indicator.stopAnimating()
        SetupViews.addViewEndRemoveAutoresizingMask(superView: self, array: [view, indicator, label])
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            indicator.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 50),
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

        ])
        stopAnimating()
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.isHidden = true
            self.indicator.stopAnimating()
            self.text = ""
        }
    }
    
    func startAnimating(_ info:InfoText! = .download) {
        self.text = info.string
        indicator.startAnimating()
        self.isHidden = false
    }

}
