import Foundation

extension URL: RandomValueProviding {

    public static var random: URL {
        return URL(string: "https://\(String.random)")!
    }

}
