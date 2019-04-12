import Foundation

extension Character: RandomValueProviding {

    public static var random: Character {
        return String.random.first!
    }

}
