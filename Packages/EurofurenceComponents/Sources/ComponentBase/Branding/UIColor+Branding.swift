import UIKit

extension UIColor {
    
    public static let placeholder = adaptiveColor(lightColor: .pantone330U, darkColor: safeSystemGray2)
    public static let pantone330U = unsafelyNamed("Pantone 330U")
    public static let pantone330U_45 = unsafelyNamed("Pantone 330U (45%)")
    public static let pantone330U_26 = unsafelyNamed("Pantone 330U (26%)")
    public static let pantone330U_13 = unsafelyNamed("Pantone 330U (13%)")
    public static let pantone330U_5 = unsafelyNamed("Pantone 330U (5%)")
    public static let largeActionButton = unsafelyNamed("Large Action Button")
    
    private static var safeSystemGray2: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray2
        } else {
            return .lightGray
        }
    }
    
    private static func unsafelyNamed(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Color named \(name) missing from xcassets")
        }
        
        return color
    }
    
    public static func adaptiveColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { (traitCollection) in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                } else {
                    return darkColor
                }
            })
        } else {
            return lightColor
        }
    }
    
}
