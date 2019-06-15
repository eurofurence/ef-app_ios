import UIKit

extension UIColor {

    static let pantone330U = UIColor.scaled(red: 0, green: 89.0, blue: 83.0)
    static let pantone330U_45 = UIColor.scaled(red: 105, green: 163, blue: 162)
    static let pantone330U_26 = UIColor.scaled(red: 162.0, green: 197.0, blue: 196.0)
    static let pantone330U_13 = UIColor.scaled(red: 203, green: 222, blue: 221)
    static let pantone330U_5 = UIColor.scaled(red: 230.0, green: 239.0, blue: 238)
    static let conferenceGrey = UIColor.scaled(red: 208.0, green: 208.0, blue: 208.0)
    
    private static func scaled(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let scale: (CGFloat) -> CGFloat = { $0 / 255.0 }
        return UIColor(red: scale(red), green: scale(green), blue: scale(blue), alpha: 1.0)
    }

}
