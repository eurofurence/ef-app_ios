import Foundation

extension IndexPath: RandomValueProviding {

    public static var random: IndexPath {
        return IndexPath(item: .random, section: .random)
    }

}
