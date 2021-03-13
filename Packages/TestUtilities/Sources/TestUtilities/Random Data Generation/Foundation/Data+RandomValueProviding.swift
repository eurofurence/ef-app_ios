import Foundation

extension Data: RandomValueProviding {

    public static var random: Data {
        guard let data = String.random.data(using: .utf8) else {
            fatalError("Failed to produce random data")
        }
        
        return data
    }

}
