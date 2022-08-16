import EurofurenceModel
import Foundation
import TestUtilities

extension Day: RandomValueProviding {

    public static var random: Day {
        return Day(date: .random, identifier: .random)
    }

}
