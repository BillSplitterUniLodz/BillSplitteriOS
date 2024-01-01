//
//  UITextField+Extension.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
extension UITextField {
    func addToolBar(_ target:Any?, action:Selector, title: String) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let buttonDone = UIBarButtonItem(title: title, style: .done, target: target, action: action)
        let flexSpase = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpase, buttonDone], animated: false)
        self.inputAccessoryView = toolBar
        toolBar.updateConstraintsIfNeeded()
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
    
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
