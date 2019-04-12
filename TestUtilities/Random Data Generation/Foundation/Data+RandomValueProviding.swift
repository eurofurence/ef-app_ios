import Foundation

extension Data: RandomValueProviding {

    public static var random: Data {
        return String.random.data(using: .utf8)!
    }

}
