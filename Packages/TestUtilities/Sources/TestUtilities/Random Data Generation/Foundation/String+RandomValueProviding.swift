import Foundation

extension String: RandomValueProviding {

    public static var random: String {
        return "\(Int.random)"
    }

}
