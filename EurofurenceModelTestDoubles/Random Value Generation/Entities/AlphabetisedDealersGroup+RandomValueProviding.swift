import EurofurenceModel
import Foundation
import TestUtilities

extension AlphabetisedDealersGroup: RandomValueProviding {

    public static var random: AlphabetisedDealersGroup {
        return AlphabetisedDealersGroup(indexingString: .random, dealers: [FakeDealer].random)
    }

}
