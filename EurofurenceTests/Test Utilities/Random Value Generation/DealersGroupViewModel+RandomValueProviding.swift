@testable import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

extension DealersGroupViewModel: RandomValueProviding {

    public static var random: DealersGroupViewModel {
        return DealersGroupViewModel(title: .random, dealers: [StubDealerViewModel].random)
    }

}
