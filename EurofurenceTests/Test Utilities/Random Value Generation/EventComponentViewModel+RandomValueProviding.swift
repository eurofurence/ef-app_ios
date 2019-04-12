@testable import Eurofurence
import EurofurenceModel
import TestUtilities

extension EventComponentViewModel: RandomValueProviding {

    public static var random: EventComponentViewModel {
        return EventComponentViewModel(startTime: .random,
                                       endTime: .random,
                                       eventName: .random,
                                       location: .random,
                                       isSponsorEvent: .random,
                                       isSuperSponsorEvent: .random,
                                       isFavourite: .random,
                                       isArtShowEvent: .random,
                                       isKageEvent: .random,
                                       isDealersDenEvent: .random,
                                       isMainStageEvent: .random,
                                       isPhotoshootEvent: .random)
    }

}
