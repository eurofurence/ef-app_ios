import Foundation.NSURL

public struct EventViewModel: Equatable {
    
    public var id: String
    public var title: String
    public var location: String
    public var formattedStartTime: String
    public var widgetURL: URL
    public var accessibilitySummary: String
    
    public init(
        id: String,
        title: String,
        location: String,
        formattedStartTime: String,
        widgetURL: URL = URL(string: "https://www.eurofurence.org").unsafelyUnwrapped,
        accessibilitySummary: String
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.formattedStartTime = formattedStartTime
        self.widgetURL = widgetURL
        self.accessibilitySummary = accessibilitySummary
    }
    
    init(
        event: Event,
        eventTimeFormatter: EventTimeFormatter,
        accessibilityFormatter: EventTimeFormatter
    ) {
        let accessibilityFormattedStartTime = accessibilityFormatter.string(from: event.startTime)
        
        let accessibilityDescriptionFormat = NSLocalizedString(
            "%@, starting at %@ in %@",
            bundle: .module,
            comment: "Format string used to prepare accessible event descriptions for widgets"
        )
        
        let englishAccessibilityDescription = String.localizedStringWithFormat(
            accessibilityDescriptionFormat,
            event.title,
            accessibilityFormattedStartTime,
            event.location
        )
        
        self.init(
            id: event.id,
            title: event.title,
            location: event.location,
            formattedStartTime: eventTimeFormatter.string(from: event.startTime),
            widgetURL: event.deepLinkingContentURL,
            accessibilitySummary: englishAccessibilityDescription
        )
    }
    
}
