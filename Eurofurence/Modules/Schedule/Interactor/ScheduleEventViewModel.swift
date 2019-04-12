import Foundation

protocol ScheduleEventViewModelProtocol {

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

}
