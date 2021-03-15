import EurofurenceModel
import Foundation
import TestUtilities

extension Track: RandomValueProviding {

    public static var random: Track {
        return Track(name: .random)
    }

}
