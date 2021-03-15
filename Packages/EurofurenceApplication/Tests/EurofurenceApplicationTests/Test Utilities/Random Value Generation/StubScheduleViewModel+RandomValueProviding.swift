import EurofurenceApplication
import EurofurenceModel
import Foundation
import TestUtilities

extension CapturingScheduleViewModel: RandomValueProviding {

    public static var random: CapturingScheduleViewModel {
        return CapturingScheduleViewModel(days: .random, events: .random, currentDay: .random)
    }

}

extension ScheduleEventGroupViewModel: RandomValueProviding {

    public static var random: ScheduleEventGroupViewModel {
        return ScheduleEventGroupViewModel(title: .random, events: [StubScheduleEventViewModel].random)
    }

}

final class StubScheduleEventViewModel: ScheduleEventViewModelProtocol {

    var title: String
    var startTime: String
    var endTime: String
    var location: String
    var bannerGraphicPNGData: Data?
    var isFavourite: Bool
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDenEvent: Bool
    var isMainStageEvent: Bool
    var isPhotoshootEvent: Bool
    var isAcceptingFeedback: Bool

    init(
        title: String,
        startTime: String,
        endTime: String,
        location: String,
        bannerGraphicPNGData: Data?,
        isFavourite: Bool,
        isSponsorOnly: Bool,
        isSuperSponsorOnly: Bool,
        isArtShow: Bool,
        isKageEvent: Bool,
        isDealersDenEvent: Bool,
        isMainStageEvent: Bool,
        isPhotoshootEvent: Bool,
        isAcceptingFeedback: Bool
    ) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.bannerGraphicPNGData = bannerGraphicPNGData
        self.isFavourite = isFavourite
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDenEvent = isDealersDenEvent
        self.isMainStageEvent = isMainStageEvent
        self.isPhotoshootEvent = isPhotoshootEvent
        self.isAcceptingFeedback = isAcceptingFeedback
    }
    
    private var observers = [ScheduleEventViewModelObserver]()
    func add(_ observer: ScheduleEventViewModelObserver) {
        observers.append(observer)
    }
    
    func favourite() {
        isFavourite = true
        observers.forEach({ $0.eventViewModelDidBecomeFavourite(self) })
    }
    
    func unfavourite() {
        isFavourite = false
        observers.forEach({ $0.eventViewModelDidBecomeNonFavourite(self) })
    }
    
    private(set) var sharedSender: Any?
    func share(_ sender: Any) {
        sharedSender = sender
    }

}

extension StubScheduleEventViewModel: RandomValueProviding {

    static var random: StubScheduleEventViewModel {
        return StubScheduleEventViewModel(
            title: .random,
            startTime: .random,
            endTime: .random,
            location: .random,
            bannerGraphicPNGData: .random,
            isFavourite: .random,
            isSponsorOnly: .random,
            isSuperSponsorOnly: .random,
            isArtShow: .random,
            isKageEvent: .random,
            isDealersDenEvent: .random,
            isMainStageEvent: .random,
            isPhotoshootEvent: .random,
            isAcceptingFeedback: .random
        )
    }

}

extension ScheduleDayViewModel: RandomValueProviding {

    public static var random: ScheduleDayViewModel {
        return ScheduleDayViewModel(title: .random)
    }

}
