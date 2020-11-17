import Foundation.NSURL

public struct EventViewModel: Equatable {
    
    public var id: String
    public var title: String
    public var location: String
    public var formattedStartTime: String
    public var formattedEndTime: String
    public var widgetURL: URL
    
    public init(
        id: String,
        title: String,
        location: String,
        formattedStartTime: String,
        formattedEndTime: String,
        widgetURL: URL = URL(string: "https://www.eurofurence.org")!
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.formattedStartTime = formattedStartTime
        self.formattedEndTime = formattedEndTime
        self.widgetURL = widgetURL
    }
    
    init(event: Event, eventTimeFormatter: EventTimeFormatter) {
        self.init(
            id: event.id,
            title: event.title,
            location: event.location,
            formattedStartTime: eventTimeFormatter.string(from: event.startTime),
            formattedEndTime: eventTimeFormatter.string(from: event.endTime),
            widgetURL: event.deepLinkingContentURL
        )
    }
    
}
