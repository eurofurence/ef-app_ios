import Foundation

public protocol ScheduleEventViewModelProtocol {

    var title: String { get }
    var startTime: String { get }
    var endTime: String { get }
    var location: String { get }
    var bannerGraphicPNGData: Data? { get }
    var isFavourite: Bool { get }
    var isSponsorOnly: Bool { get }
    var isSuperSponsorOnly: Bool { get }
    var isArtShow: Bool { get }
    var isKageEvent: Bool { get }
    var isDealersDenEvent: Bool { get }
    var isMainStageEvent: Bool { get }
    var isPhotoshootEvent: Bool { get }
    
    func add(_ observer: ScheduleEventViewModelObserver)
    func favourite()
    func unfavourite()

}

public protocol ScheduleEventViewModelObserver: class {
    
    func eventViewModelDidBecomeFavourite(_ viewModel: ScheduleEventViewModelProtocol)
    func eventViewModelDidBecomeNonFavourite(_ viewModel: ScheduleEventViewModelProtocol)
    
}
