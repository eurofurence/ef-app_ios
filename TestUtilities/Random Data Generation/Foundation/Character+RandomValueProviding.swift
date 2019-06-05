import Foundation

extension Character: RandomValueProviding {

    public static var random: Character {
        return unwrap(String.random.first)
    }

}
