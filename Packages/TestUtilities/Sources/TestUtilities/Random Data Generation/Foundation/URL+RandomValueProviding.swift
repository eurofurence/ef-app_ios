import Foundation

extension URL: RandomValueProviding {

    public static var random: URL {
        guard let url = URL(string: "https://\(String.random)") else {
            fatalError("Failed to produce random URL")
        }
        
        return url
    }

}
