import SwiftUI
import UIKit

extension Color {
    
    public static let pantone330U = Color("Pantone 330U", bundle: .moduleWorkaround)
    
}

extension UIColor {
    
    // MARK: Branding Colors
    
    public static let pantone330U = unsafelyNamed("Pantone 330U")
    public static let pantone330U_45 = unsafelyNamed("Pantone 330U (45%)")
    public static let pantone330U_26 = unsafelyNamed("Pantone 330U (26%)")
    public static let pantone330U_13 = unsafelyNamed("Pantone 330U (13%)")
    public static let pantone330U_5 = unsafelyNamed("Pantone 330U (5%)")
    public static let largeActionButton = unsafelyNamed("Large Action Button")
    
    // MARK: Semantic Control Colors
    
    public static let efTintColor = adaptive(light: .pantone330U, dark: .pantone330U_45)
    public static let disabledColor = safeSystemGray
    public static let navigationBar = barColor
    public static let tabBar = barColor
    public static let searchBarTint = pantone330U
    public static let refreshControl = pantone330U_13
    public static let selectedTabBarItem = adaptive(light: .white, dark: .pantone330U_13)
    public static let unselectedTabBarItem = adaptive(light: .pantone330U_45, dark: .systemGray3)
    public static let primary = adaptive(light: .pantone330U, dark: .black)
    public static let secondary = adaptive(light: .pantone330U_45, dark: .secondaryDarkColor)
    public static let buttons = pantone330U
    public static let tableIndex = pantone330U
    public static let iconographicTint = pantone330U
    public static let unreadIndicator = pantone330U
    public static let selectedSegmentText = adaptive(light: .pantone330U, dark: .white)
    public static let selectedSegmentBackground = adaptive(light: .white, dark: .safeSystemGray)
    public static let unselectedSegmentText = adaptive(light: .white, dark: .white)
    public static let unselectedSegmentBackground = adaptive(light: .pantone330U_45, dark: .safeSystemGray3)
    public static let segmentSeperator = adaptive(light: .white, dark: .safeSystemGray)
    public static let dayPickerSelectedBackground = adaptive(light: .pantone330U_45, dark: .systemGray3)
    public static let safariBarTint = navigationBar
    public static let safariControlTint = white
    public static let userPrompt = adaptive(
        light: UIColor(white: 0.5, alpha: 1.0),
        dark: .safeSystemGray
    )
    
    public static let userPromptWithUnreadMessages = pantone330U
    
    private static let barColor: UIColor = adaptive(light: .pantone330U, dark: calendarStyleBarColor)
    
    private static var calendarStyleBarColor: UIColor {
        scaled(red: 18, green: 19, blue: 18)
    }
    
    private static var secondaryDarkColor = UIColor.opaqueSeparator
    
    private static var safeSystemGray = UIColor.systemGray
    
    private static var safeSystemGray3 = UIColor.systemGray3
    
    private static func scaled(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let scale: (CGFloat) -> CGFloat = { $0 / 255.0 }
        return UIColor(red: scale(red), green: scale(green), blue: scale(blue), alpha: 1.0)
    }
    
    func makeColoredImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    func makePixel() -> UIImage {
        makeColoredImage(size: CGSize(width: 1, height: 1))
    }
    
    private static var safeSystemGray2 = UIColor.systemGray2
    
    private static func unsafelyNamed(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Color named \(name) missing from xcassets")
        }
        
        return color
    }
    
    public static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor(dynamicProvider: { (traitCollection) in
            if traitCollection.userInterfaceStyle == .light {
                return light
            } else {
                return dark
            }
        })
    }
    
}
