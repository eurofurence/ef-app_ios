import Foundation

extension String: RandomValueProviding {

    public static var random: String {
        return "\(arc4random())"
    }

}
