import DealerComponent
import EurofurenceModel
import TestUtilities

extension DealerDetailLocationAndAvailabilityViewModel: RandomValueProviding {

    public static var random: DealerDetailLocationAndAvailabilityViewModel {
        return DealerDetailLocationAndAvailabilityViewModel(title: .random,
                                                            mapPNGGraphicData: .random,
                                                            limitedAvailabilityWarning: .random,
                                                            locatedInAfterDarkDealersDenMessage: .random)
    }

}
