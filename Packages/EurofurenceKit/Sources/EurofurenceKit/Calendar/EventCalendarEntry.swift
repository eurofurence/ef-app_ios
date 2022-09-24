import Foundation

public struct EventCalendarEntry: Hashable {
    
    public var title: String
    public var startDate: Date
    public var endDate: Date
    public var location: String
    public var shortDescription: String
    public var url: URL?
    
    public init(
        title: String,
        startDate: Date,
        endDate: Date,
        location: String,
        shortDescription: String,
        url: URL? = nil
    ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.shortDescription = shortDescription
        self.url = url
    }
    
}
