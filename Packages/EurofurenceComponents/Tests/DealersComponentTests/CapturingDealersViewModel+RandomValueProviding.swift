import EurofurenceModel
import Foundation
import TestUtilities

extension CapturingDealersViewModel: RandomValueProviding {

    public static var random: CapturingDealersViewModel {
        return CapturingDealersViewModel(dealerGroups: .random)
    }

}
