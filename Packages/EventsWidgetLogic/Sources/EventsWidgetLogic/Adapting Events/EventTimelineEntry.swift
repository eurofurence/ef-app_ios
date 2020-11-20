import Foundation

public struct EventTimelineEntry: Equatable {
    
    public struct Context: Equatable {
        
        public let category: EventCategory
        public let isFavouritesOnly: Bool
        
        public init(category: EventCategory, isFavouritesOnly: Bool) {
            self.category = category
            self.isFavouritesOnly = isFavouritesOnly
        }
        
    }
    
    public var date: Date
    public var events: [EventViewModel]
    public var additionalEventsCount: Int
    public var context: Context
    
    public init(
        date: Date,
        events: [EventViewModel],
        additionalEventsCount: Int,
        context: Context
    ) {
        self.date = date
        self.events = events
        self.additionalEventsCount = additionalEventsCount
        self.context = context
    }
    
}
