import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

extension EventSummaryViewModel: RandomValueProviding {

    public static var random: EventSummaryViewModel {
        return EventSummaryViewModel(title: .random,
                                     subtitle: .random,
                                     abstract: .random,
                                     eventStartEndTime: .random,
                                     location: .random,
                                     trackName: .random,
                                     eventHosts: .random)
    }

}
