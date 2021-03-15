import EurofurenceApplication
import EurofurenceModel
import Foundation
import TestUtilities

extension StubDealerViewModel: RandomValueProviding {

    public static var random: StubDealerViewModel {
        return StubDealerViewModel()
    }

}
