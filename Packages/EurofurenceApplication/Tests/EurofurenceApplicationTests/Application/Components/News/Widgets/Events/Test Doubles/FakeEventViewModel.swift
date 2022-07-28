import EurofurenceApplication
import ObservedObject

class FakeEventViewModel: EventViewModel {
    
    @Observed var name: String
    @Observed var location: String
    @Observed var startTime: String
    @Observed var endTime: String
    @Observed var isFavourite: Bool
    @Observed var isSponsorOnly: Bool
    @Observed var isSuperSponsorOnly: Bool
    @Observed var isArtShow: Bool
    @Observed var isKageEvent: Bool
    @Observed var isDealersDen: Bool
    @Observed var isMainStage: Bool
    @Observed var isPhotoshoot: Bool
    @Observed var isFaceMaskRequired: Bool
    
    init(
        name: String = "Name",
        location: String = "Location",
        startTime: String = "Start Time",
        endTime: String = "End Time",
        isFavourite: Bool = false,
        isSponsorOnly: Bool = false,
        isSuperSponsorOnly: Bool = false,
        isArtShow: Bool = false,
        isKageEvent: Bool = false,
        isDealersDen: Bool = false,
        isMainStage: Bool = false,
        isPhotoshoot: Bool = false,
        isFaceMaskRequired: Bool = false
    ) {
        self.name = name
        self.location = location
        self.startTime = startTime
        self.endTime = endTime
        self.isFavourite = isFavourite
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDen = isDealersDen
        self.isMainStage = isMainStage
        self.isPhotoshoot = isPhotoshoot
        self.isFaceMaskRequired = isFaceMaskRequired
    }
    
}
