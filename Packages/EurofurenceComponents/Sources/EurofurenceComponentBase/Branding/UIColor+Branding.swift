import UIKit

extension UIColor {
    
    public static let pantone330U = unsafelyNamed("Pantone 330U")
    public static let pantone330U_45 = unsafelyNamed("Pantone 330U (45%)")
    public static let pantone330U_26 = unsafelyNamed("Pantone 330U (26%)")
    public static let pantone330U_13 = unsafelyNamed("Pantone 330U (13%)")
    public static let pantone330U_5 = unsafelyNamed("Pantone 330U (5%)")
    public static let largeActionButton = unsafelyNamed("Large Action Button")
    
    private static func unsafelyNamed(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Color named \(name) missing from xcassets")
        }
        
        return color
    }
    
}
