//
//  UIView+Extension.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import UIKit

extension UIView {
    
    func fullConstraint(view:UIView? = nil, top:CGFloat! = 0, bottom:CGFloat! = 0, leading:CGFloat! = 0, trailing:CGFloat! = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: (view ?? self.superview!).topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: (view ?? self.superview!).bottomAnchor, constant: bottom),
            self.leadingAnchor.constraint(equalTo: (view ?? self.superview!).leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: (view ?? self.superview!).trailingAnchor, constant: trailing),
        ])
    }
    
    func fullConstraintSafeAria(view:UIView? = nil, top:CGFloat! = 0, bottom:CGFloat! = 0, leading:CGFloat! = 0, trailing:CGFloat! = 0, safeArea:Bool! = true, safeAreaBottom:Bool! = false) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let view = view ?? self.superview else { return  }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: (safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor), constant: top),
            self.bottomAnchor.constraint(equalTo: (safeAreaBottom ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor), constant: bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
        ])
    }
    
    convenience init(_ backgroundColor:UIColor, radius:CGFloat) {
        self.init()
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
    }
    
    convenience init(_ color:UIColor) {
        self.init()
        self.backgroundColor = color
    }
    
    func testShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func shadow(_ color: UIColor? = nil) {
        let newColor = color ?? UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        self.layer.shadowColor = newColor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.5
    }
    
    func gradientLargeView(from: UIView.Point, to: UIView.Point, startColor: UIColor, endColor: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
        gradientLayer.locations = [0,1.1]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
            return self.applyGradient(colours: colours, locations: nil)
        }


    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing

        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeading:
                return CGPoint(x: 0, y: 1.0)
            case .top:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .topTrailing:
                return CGPoint(x: 1.0, y: 0.0)
            case .trailing:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
}
