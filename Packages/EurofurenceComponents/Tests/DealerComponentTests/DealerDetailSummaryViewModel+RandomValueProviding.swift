import DealerComponent
import EurofurenceModel
import Foundation
import TestUtilities

extension DealerDetailSummaryViewModel: RandomValueProviding {

    public static var random: DealerDetailSummaryViewModel {
        return DealerDetailSummaryViewModel(artistImagePNGData: .random,
                                            title: .random,
                                            subtitle: .random,
                                            categories: .random,
                                            shortDescription: .random,
                                            website: .random,
                                            twitterHandle: .random,
                                            telegramHandle: .random)
    }

}
