import EurofurenceModel
import Foundation
import ScheduleComponent
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

public final class StubScheduleEventViewModel: ScheduleEventViewModelProtocol {

    public var title: String
    public var startTime: String
    public var endTime: String
    public var location: String
    public var bannerGraphicPNGData: Data?
    public var isFavourite: Bool
    public var isSponsorOnly: Bool
    public var isSuperSponsorOnly: Bool
    public var isArtShow: Bool
    public var isKageEvent: Bool
    public var isDealersDenEvent: Bool
    public var isMainStageEvent: Bool
    public var isPhotoshootEvent: Bool
    public var isAcceptingFeedback: Bool
    public var isFaceMaskRequired: Bool

    public init(
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
        isAcceptingFeedback: Bool,
        isFaceMaskRequired: Bool
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
        self.isFaceMaskRequired = isFaceMaskRequired
    }
    
    private var observers = [ScheduleEventViewModelObserver]()
    public func add(_ observer: ScheduleEventViewModelObserver) {
        observers.append(observer)
    }
    
    public func favourite() {
        isFavourite = true
        observers.forEach({ $0.eventViewModelDidBecomeFavourite(self) })
    }
    
    public func unfavourite() {
        isFavourite = false
        observers.forEach({ $0.eventViewModelDidBecomeNonFavourite(self) })
    }
    
    public private(set) var sharedSender: Any?
    public func share(_ sender: Any) {
        sharedSender = sender
    }

}

extension StubScheduleEventViewModel: RandomValueProviding {

    public static var random: StubScheduleEventViewModel {
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
            isAcceptingFeedback: .random,
            isFaceMaskRequired: .random
        )
    }

}

extension ScheduleDayViewModel: RandomValueProviding {

    public static var random: ScheduleDayViewModel {
        return ScheduleDayViewModel(title: .random)
    }

}
