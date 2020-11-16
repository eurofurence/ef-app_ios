public struct EventViewModel: Equatable {
    
    public var id: String
    public var title: String
    public var location: String
    public var formattedStartTime: String
    public var formattedEndTime: String
    
    public init(
        id: String,
        title: String,
        location: String = "",
        formattedStartTime: String = "",
        formattedEndTime: String = ""
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.formattedStartTime = formattedStartTime
        self.formattedEndTime = formattedEndTime
    }
    
    init(event: Event) {
        self.init(id: event.id, title: event.title)
    }
    
    init(event: Event, eventTimeFormatter: EventTimeFormatter) {
        self.init(
            id: event.id,
            title: event.title,
            formattedStartTime: eventTimeFormatter.string(from: event.startTime),
            formattedEndTime: eventTimeFormatter.string(from: event.endTime)
        )
    }
    
}
