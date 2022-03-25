import ComponentBase
import EurofurenceModel
import Foundation

protocol NewsViewModelComponent {
    
    var childCount: Int { get }
    var title: String { get }
    
    func announceContent(at index: Int, to visitor: NewsViewModelVisitor)
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void)
    
}

struct DefaultNewsViewModel: NewsViewModel {
    
    private let components: [NewsViewModelComponent]
    
    init(components: [NewsViewModelComponent]) {
        self.components = components
    }
    
    var numberOfComponents: Int {
        return components.count
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return components[index].childCount
    }
    
    func titleForComponent(at index: Int) -> String {
        return components[index].title
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        let component = components[indexPath.section]
        component.announceContent(at: indexPath.item, to: visitor)
    }
    
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        components[indexPath.section].announceValue(at: indexPath.item, to: completionHandler)
    }
    
}

struct NewsViewModelUserComponent: NewsViewModelComponent {
    
    private let viewModel: UserWidgetComponentViewModel
    
    init(viewModel: UserWidgetComponentViewModel) {
        self.viewModel = viewModel
    }
    
    var childCount: Int { return 1 }
    var title: String { return .yourEurofurence }
    
    func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
        visitor.visit(viewModel)
    }
    
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
        completionHandler(.messages)
    }
    
}

struct NewsViewModelCountdownComponent: NewsViewModelComponent {
    
    private let viewModel: ConventionCountdownComponentViewModel
    
    init(daysUntilConvention: Int) {
        let message = String.daysUntilConventionMessage(days: daysUntilConvention)
        viewModel = ConventionCountdownComponentViewModel(timeUntilConvention: message)
    }
    
    var childCount: Int {
        return 1
    }
    
    var title: String {
        return .daysUntilConvention
    }
    
    func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
        visitor.visit(viewModel)
    }
    
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
        
    }
    
}

struct NewsViewModelAnnouncementsComponent: NewsViewModelComponent {
    
    private let announcements: [Announcement]
    private let viewModels: [AnnouncementItemViewModel]
    
    init(announcements: [Announcement],
         readAnnouncements: [AnnouncementIdentifier],
         announcementsDateFormatter: AnnouncementDateFormatter,
         markdownRenderer: MarkdownRenderer) {
        self.announcements = announcements
        viewModels = announcements.map({ (announcement) -> AnnouncementItemViewModel in
            AnnouncementItemViewModel(
                title: announcement.title,
                detail: markdownRenderer.render(announcement.content),
                receivedDateTime: announcementsDateFormatter.string(from: announcement.date),
                isRead: readAnnouncements.contains(announcement.identifier)
            )
        })
    }
    
    var childCount: Int { return viewModels.count + 1 }
    var title: String { return .announcements }
    
    func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
        switch index {
        case 0:
            visitor.visit(ViewAllAnnouncementsComponentViewModel(caption: .allAnnouncements))
            
        default:
            let viewModel = viewModels[index - 1]
            visitor.visit(viewModel)
        }
    }
    
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
        switch index {
        case 0:
            completionHandler(.allAnnouncements)
            
        default:
            let announcement = announcements[index - 1]
            completionHandler(.announcement(announcement.identifier))
        }
    }
    
}

struct NewsViewModelEventsComponent: NewsViewModelComponent {
    
    private let events: [Event]
    private let viewModels: [EventComponentViewModel]
    
    init(title: String,
         events: [Event],
         favouriteEventIdentifiers: [EventIdentifier],
         startTimeFormatter: (Event) -> String,
         hoursDateFormatter: HoursDateFormatter) {
        self.title = title
        self.events = events
        
        viewModels = events.map { (event) -> EventComponentViewModel in
            return EventComponentViewModel(startTime: startTimeFormatter(event),
                                           endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                           eventName: event.title,
                                           location: event.room.name,
                                           isSponsorEvent: event.isSponsorOnly,
                                           isSuperSponsorEvent: event.isSuperSponsorOnly,
                                           isFavourite: favouriteEventIdentifiers.contains(event.identifier),
                                           isArtShowEvent: event.isArtShow,
                                           isKageEvent: event.isKageEvent,
                                           isDealersDenEvent: event.isDealersDen,
                                           isMainStageEvent: event.isMainStage,
                                           isPhotoshootEvent: event.isPhotoshoot)
        }
    }
    
    var title: String
    
    var childCount: Int {
        return viewModels.count
    }
    
    func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
        let viewModel = viewModels[index]
        visitor.visit(viewModel)
    }
    
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
        let event = events[index]
        completionHandler(.event(event))
    }
    
}
