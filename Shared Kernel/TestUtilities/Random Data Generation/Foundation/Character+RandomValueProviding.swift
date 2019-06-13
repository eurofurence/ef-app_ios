import Foundation

extension Character: RandomValueProviding {

    public static var random: Character {
        guard let character = String.random.first else {
            fatalError("Failed to produce random Character")
        }
        
        return character
    }

}
