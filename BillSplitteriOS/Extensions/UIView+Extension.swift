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


extension UIColor {
    class var custom: CustomColor { return CustomColor() }
    
    struct CustomColor {
        //синий
        var blue:  UIColor { return UIColor(named: "blue") ?? UIColor(red: 0.168627451, green: 0.3254901961, blue: 0.8392156863, alpha: 1)}
        
        //белый
        var white: UIColor { return UIColor(named: "white") ?? UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1) }
        
        //
        var black: UIColor { return UIColor(named: "black") ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1) }
        
        
        
        
        //зеленый
        var green: UIColor { return UIColor(named: "green") ?? UIColor(red: 97/255, green: 165/255, blue: 53/255, alpha: 1) }
        
        //крассный
        var red: UIColor { return UIColor(named: "red") ?? UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1) }
       
        //темно серый
        var darkGray: UIColor { return UIColor(named: "darkGray") ?? UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)}
        
        //серый
        var gray:  UIColor { return UIColor(named: "gray") ?? UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)}
        
        //серый
        var gray6:  UIColor {  return UIColor(named: "gray6") ?? UIColor(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)}
        
        //серый
        var gray3:  UIColor { return UIColor(named: "gray3") ?? UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)}
        
        //Серый число календаря
        var grayDate: UIColor {return UIColor.hexStringToUIColor(hex: "#7B7D81")}

        //цвет фона контроллера
//        var backgroundColor:  UIColor { return UIColor(named: "backgroundColor") ?? UIColor(red: 0.9882352941, green: 0.9882352941, blue: 0.9882352941, alpha: 1)}
        
        //
        var grayView:  UIColor { return UIColor(named: "grayView") ?? UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)}
        
        var labelColor: UIColor {return UIColor(named: "labelColor") ?? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) }
        
        var cellColor: UIColor {return UIColor(named: "cellColor") ?? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) }
        
        //легкий серый цвет (используется в основном с TextField backgroundColor или как borderColor
        var lightGray: UIColor { return UIColor(named: "lightGray") ??  UIColor(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1) }
        
        //#colorLiteral(red: 0.9960784314, green: 0.7568627451, blue: 0.01568627451, alpha: 1)
        
        //#colorLiteral(red: 0.7333333333, green: 0.231372549, blue: 0.231372549, alpha: 1)
        
        var mainBackgroundColor: UIColor { return UIColor(red: 0.08, green: 0.7, blue: 0.89, alpha: 1)}
        var cellBackgroundColor: UIColor {return UIColor(red: 0.1, green: 0.79, blue: 1, alpha: 1)}
        var buttonBackgroundColor: UIColor {return UIColor(red: 0.42, green: 0.74, blue: 0.96, alpha: 1)}
        var buttonGreenBgColor: UIColor {return UIColor(red: 0.39, green: 0.84, blue: 0.53, alpha: 1)}
        var dateBackgroundColor: UIColor { return UIColor.hexStringToUIColor(hex: "#E1F8F7")}
        var subtitleColor: UIColor { return UIColor.hexStringToUIColor(hex: "#6E7599")}
    }
    
    
    static let arrayOfBorderColors = [UIColor.hexStringToUIColor(hex: "#63D586"),
                               UIColor.hexStringToUIColor(hex: "#C7A9F5"),
                               UIColor.hexStringToUIColor(hex: "#FFA607"),
                               UIColor.hexStringToUIColor(hex: "#6CDDFF"),
                               UIColor.hexStringToUIColor(hex: "#FFC600"),
                               UIColor.hexStringToUIColor(hex: "#F09272"),
                               UIColor.hexStringToUIColor(hex: "#1E90FF"),
                               UIColor.hexStringToUIColor(hex: "#FEF6DC"),
                               UIColor.hexStringToUIColor(hex: "#D3E2EC"),
                               UIColor.hexStringToUIColor(hex: "#3796B3")
    ]
    
}


extension UIColor {
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: - Label
import UIKit

extension UILabel {
    
    convenience init(text:String, ofSize fontSize: CGFloat, weight: UIFont.Weight, color:UIColor? = .custom.black) {
        self.init()
        self.text = text
        self.backgroundColor = .clear
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
    }
    
    convenience init(text:String?, size fontSize: CGFloat, weight: UIFont.Weight, color:UIColor? = .custom.black) {
        self.init()
        self.text = text
        self.backgroundColor = .clear
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textColor = color
    }
    
    convenience init(text:String?, font: UIFont, color:UIColor? = .custom.black) {
        self.init()
        self.text = text
        self.backgroundColor = .clear
        self.font = font
        self.textColor = color
    }
}

//MARK: - TextField
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


class SetupViews {
    private init() {}
    static var shared = SetupViews()
    
    static func addViewEndRemoveAutoresizingMask(superView:UIView, array views: [UIView]) {
        for row in 0...views.count - 1 {
            superView.addSubview(views[row])
            views[row].translatesAutoresizingMaskIntoConstraints = false
        }
    }
    static func addViewEndRemoveAutoresizingMask(superView:UIView,  view: UIView) {
        superView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    convenience init(backgroundColor:UIColor, textColor:UIColor, text:String, radius:CGFloat! = 0) {
        self.init()
        self.backgroundColor = backgroundColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(.custom.darkGray, for: .focused)
        self.setTitleColor(.custom.darkGray, for: .highlighted)
//        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.clipsToBounds = true
        self.titleLabel?.font = .montserratFont(ofSize: 13, weight: .bold)
        self.layer.cornerRadius = radius
    }
    
    convenience init(color:UIColor, backgroundColor:UIColor,  image:UIImage?) {
        self.init()
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
//        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.clipsToBounds = true
    }
    
    convenience init(backgroundColor:UIColor,  image:UIImage?) {
        self.init()
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        self.clipsToBounds = true
    }
    
    
    func leftImage(left: CGFloat = 5, right: CGFloat = 5) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        self.titleEdgeInsets.left = (self.imageView?.frame.width ?? 0)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
}


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
