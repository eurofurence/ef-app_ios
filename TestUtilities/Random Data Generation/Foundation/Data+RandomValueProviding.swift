import Foundation

extension Data: RandomValueProviding {

    public static var random: Data {
        return unwrap(String.random.data(using: .utf8))
    }

}
