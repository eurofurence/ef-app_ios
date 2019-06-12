import Foundation

extension Date: RandomValueProviding {

    public static var random: Date {
        return Date(timeIntervalSince1970: .random)
    }

}
