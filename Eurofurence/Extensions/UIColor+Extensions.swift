import UIKit

extension UIColor {
    
    static func adaptiveColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
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
    
    static let tintColor = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    static let navigationBar = adaptiveColor(lightColor: .pantone330U, darkColor: .black)
    static let tabBar = adaptiveColor(lightColor: .pantone330U, darkColor: .black)
    static let selectedTabBarItem = adaptiveColor(lightColor: .white, darkColor: .pantone330U_45)
    static let unselectedTabBarItem = adaptiveColor(lightColor: .pantone330U_45, darkColor: .darkGray)
    static let primary = adaptiveColor(lightColor: .pantone330U, darkColor: .black)
    static let secondary = adaptiveColor(lightColor: .pantone330U_45, darkColor: .secondaryDarkColor)
    static let buttons = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    static let iconographicTint = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    static let unreadIndicator = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    static let selectedSegmentText = adaptiveColor(lightColor: .pantone330U, darkColor: .white)
    static let selectedSegmentBackground = adaptiveColor(lightColor: .white, darkColor: .safeSystemGray)
    static let unselectedSegmentText = adaptiveColor(lightColor: .white, darkColor: .white)
    static let unselectedSegmentBackground = adaptiveColor(lightColor: .pantone330U_45, darkColor: .safeSystemGray3)
    static let segmentSeperator = adaptiveColor(lightColor: .white, darkColor: .safeSystemGray)
    static let safariBarTint = UIColor.navigationBar
    static let safariControlTint = UIColor.white
    static let userPrompt = adaptiveColor(
        lightColor: UIColor(white: 0.5, alpha: 1.0),
        darkColor: .safeSystemGray
    )
    
    static let userPromptWithUnreadMessages = adaptiveColor(lightColor: .pantone330U, darkColor: .pantone330U_45)
    
    private static var secondaryDarkColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .opaqueSeparator
        } else {
            return .black
        }
    }()
    
    private static var safeSystemGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        } else {
            return .lightGray
        }
    }
    
    private static var safeSystemGray3: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return .darkGray
        }
    }
    
    static let pantone330U = UIColor.named("Pantone 330U", defaultingToRed: 0, green: 89, blue: 83)
    
    static let pantone330U_45 = UIColor.named("Pantone 330U (45%)", defaultingToRed: 105, green: 163, blue: 162)
    static let pantone330U_26 = UIColor.named("Pantone 330U (26%)", defaultingToRed: 162.0, green: 197.0, blue: 196.0)
    static let pantone330U_13 = UIColor.named("Pantone 330U (13%)", defaultingToRed: 203, green: 222, blue: 221)
    static let pantone330U_5 = UIColor.named("Pantone 330U (5%)", defaultingToRed: 230.0, green: 239.0, blue: 238)
    static let conferenceGrey = UIColor.named("Conference Grey", defaultingToRed: 208.0, green: 208.0, blue: 208.0)
    
    private static func scaled(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let scale: (CGFloat) -> CGFloat = { $0 / 255.0 }
        return UIColor(red: scale(red), green: scale(green), blue: scale(blue), alpha: 1.0)
    }
    
    private static func named(
        _ name: String,
        defaultingToRed red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) -> UIColor {
        if #available(iOS 11.0, *) {
            return unwrapNamedColor(name)
        } else {
            return .scaled(red: red, green: green, blue: blue)
        }
    }
    
    @available(iOS 11.0, *)
    private static func unwrapNamedColor(_ name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("Color named \(name) missing from bundle")
        }
        
        return color
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

}
