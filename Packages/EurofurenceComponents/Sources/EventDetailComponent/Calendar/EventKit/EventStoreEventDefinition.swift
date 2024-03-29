import Foundation

public struct EventStoreEventDefinition: Hashable {
    
    let identifier: String
    let title: String
    let room: String
    let startDate: Date
    let endDate: Date
    let deeplinkURL: URL
    let shortDescription: String
    
    public init(
        identifier: String,
        title: String,
        room: String,
        startDate: Date,
        endDate: Date,
        deeplinkURL: URL,
        shortDescription: String
    ) {
        self.identifier = identifier
        self.title = title
        self.room = room
        self.startDate = startDate
        self.endDate = endDate
        self.deeplinkURL = deeplinkURL
        self.shortDescription = shortDescription
    }
    
}
