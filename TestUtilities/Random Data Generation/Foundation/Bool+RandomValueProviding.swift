import Foundation

extension Bool: RandomValueProviding {

    public static var random: Bool {
        return Int.random(upperLimit: 100) % 2 == 0
    }

}
