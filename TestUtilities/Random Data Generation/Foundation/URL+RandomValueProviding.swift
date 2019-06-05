import Foundation

extension URL: RandomValueProviding {

    public static var random: URL {
        return unwrap(URL(string: "https://\(String.random)"))
    }

}
