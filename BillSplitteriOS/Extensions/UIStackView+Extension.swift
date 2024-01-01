//
//  UIStackView+Extension.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit
extension UIStackView {
    
    convenience init(_ axis: NSLayoutConstraint.Axis,
                           _ distribution:UIStackView.Distribution,
                           _ alignment: UIStackView.Alignment,
                           _ spacing: CGFloat,
                           _ arrangedSubviews: [UIView] ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.backgroundColor = .clear
    }
}
