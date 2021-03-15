import Foundation

extension Bool: RandomValueProviding {

    public static var random: Bool {
        return Int.random(upperLimit: 100).isMultiple(of: 2)
    }

}
