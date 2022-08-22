import Foundation

public struct EventStoreEventDefinition: Equatable {
    
    let identifier: String
    let title: String
    let startDate: Date
    let endDate: Date
    let deeplinkURL: URL
    
    public init(identifier: String, title: String, startDate: Date, endDate: Date, deeplinkURL: URL) {
        self.identifier = identifier
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.deeplinkURL = deeplinkURL
    }
    
}
