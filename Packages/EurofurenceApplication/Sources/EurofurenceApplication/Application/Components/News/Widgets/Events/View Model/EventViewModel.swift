import ObservedObject

public protocol EventViewModel: ObservedObject {
    
    var name: String { get }
    var location: String { get }
    var startTime: String { get }
    var endTime: String { get }
    var isFavourite: Bool { get }
    var isSponsorOnly: Bool { get }
    var isSuperSponsorOnly: Bool { get }
    var isArtShow: Bool { get }
    var isKageEvent: Bool { get }
    var isDealersDen: Bool { get }
    var isMainStage: Bool { get }
    var isPhotoshoot: Bool { get }
    var isFaceMaskRequired: Bool { get }
    
}
