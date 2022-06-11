import Foundation

public struct EventTimelineEntry: Equatable {
    
    public enum Content: Equatable {
        
        case events(viewModels: [EventViewModel])
        case empty
        
    }
    
    public struct Context: Equatable {
        
        public let category: EventCategory
        public let isFavouritesOnly: Bool
        
        public init(category: EventCategory, isFavouritesOnly: Bool) {
            self.category = category
            self.isFavouritesOnly = isFavouritesOnly
        }
        
    }
    
    public var date: Date
    public var accessibleSummary: String
    public var content: Content
    public var context: Context
    
    public init(date: Date, accessibleSummary: String, content: Content, context: Context) {
        self.date = date
        self.accessibleSummary = accessibleSummary
        self.content = content
        self.context = context
    }
    
}
