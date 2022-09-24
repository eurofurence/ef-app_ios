import Combine
import CoreData
import EurofurenceWebAPI
import Logging

@objc(Event)
public class Event: Entity {
    
    private static let logger = Logger(label: "Event")
    private var subscriptions = Set<AnyCancellable>()

    @nonobjc class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var acceptingFeedback: Bool
    @NSManaged public var deviatingFromConbook: Bool
    @NSManaged public var endDate: Date
    @NSManaged public var eventDescription: String
    @NSManaged public var slug: String
    @NSManaged public var startDate: Date
    @NSManaged public var subtitle: String
    @NSManaged public var title: String
    @NSManaged public var banner: EventBanner?
    @NSManaged public var day: Day
    @NSManaged public var panelHosts: Set<PanelHost>
    @NSManaged public var poster: EventPoster?
    @NSManaged public var room: Room
    @NSManaged public var track: Track
    @NSManaged public var tags: Set<Tag>
    
    /// Indicates whether the receiver has been included in the user's collection of favourite events.
    @NSManaged public internal(set) var isFavourite: Bool
    
    /// Indicates whether the receiver has been added to a system calendar.
    public var isPresentInCalendar: Bool {
        get {
            willAccessValue(forKey: nil)
            return eventsCalendar.contains(entry: calendarEntry)
        }
    }
    
    /// Computes a stable `URL` for referencing this `Event` between the local model and the remote Eurofurence
    /// web API.
    public var contentURL: URL {
        eurofurenceAPI.url(for: .event(id: identifier))
    }
    
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        listenForCalendarChanges()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
    
    /// Adds the receiver to the user's collection of favourited events.
    public func favourite() async {
        if isFavourite == false {
            await updateFavouriteState(to: true, loggingDescription: "add event to favourites")
        }
    }
    
    /// Removes the receiver from the user's collection of favourited events.
    public func unfavourite() async {
        if isFavourite {
            await updateFavouriteState(to: false, loggingDescription: "remove event from favourites")
        }
    }
    
    private func updateFavouriteState(to newState: Bool, loggingDescription: StaticString) async {
        guard let persistentContainer = managedObjectContext?.persistentContainer else { return }
        
        let writingContext = persistentContainer.newBackgroundContext()
        let eventID = objectID
        let identifier = self.identifier
        
        do {
            try await writingContext.performAsync { [writingContext] in
                guard let writableEvent = writingContext.object(with: eventID) as? Event else { return }
                
                writableEvent.isFavourite = newState
                try writingContext.save()
            }
        } catch {
            let metadata: Logger.Metadata = [
                "ID": .string(identifier),
                "Error": .string(String(describing: error))
            ]
            
            Self.logger.error("Failed to \(loggingDescription)", metadata: metadata)
        }
    }

}

// MARK: - Notifications

extension NSNotification.Name {
    
    /// A notification that is posted when the user has submitted feedback for an event that has been received by the
    /// events team. This notification is posted on the main actor.
    ///
    /// The object associated with the notification is the `Event` in which feedback has been submitted for.
    public static let EFKEventFeedbackSubmitted = Notification.Name("EFKEventFeedbackSubmitted")
    
}

// MARK: - Tags

extension Event {
    
    /// The collection of well-known tags associated with this event.
    public var canonicalTags: [CanonicalTag] {
        var tags = [CanonicalTag]()
        for tag in self.tags.compactMap(\.canonicalTag) {
            tags.append(tag)
        }
        
        return tags.sorted()
    }
    
}

// MARK: - Feedback

extension Event {
    
    /// An input mechanism for collecting and sending feedback for an event.
    public class FeedbackForm: Identifiable, ObservableObject {
        
        public var id: String {
            event.identifier
        }
        
        private let event: Event
        private let api: EurofurenceAPI
        
        init(event: Event, api: EurofurenceAPI) {
            self.event = event
            self.api = api
        }
        
        /// The rating of the event.
        @Published public var rating: Rating = 3
        
        /// Additional comments supplied by the user regarding the event.
        @Published public var additionalComments: String = ""
        
        /// Submits this feedback to the events team for processing.
        public func submit() async throws {
            let request = APIRequests.SubmitEventFeedback(
                identifier: event.identifier,
                rating: rating.value,
                additionalComments: additionalComments
            )
            
            do {
                try await api.execute(request: request)
                await MainActor.run {
                    NotificationCenter.default.post(name: .EFKEventFeedbackSubmitted, object: event)
                }
            } catch {
                throw EurofurenceError.feedbackSubmissionFailed
            }
        }
        
    }
    
    /// Specifies a value the user has associated with the event to express their satisfaction with its content and
    /// execution.
    public struct Rating: Equatable, ExpressibleByIntegerLiteral {
        
        /// The smallest possible rating value permitted by the model.
        public static let smallestPossibleRatingValue = 1
        
        /// The largest possible rating value permitted by the model.
        public static let largestPossibleRatingValue = 5
        
        public typealias IntegerLiteralType = Int
        
        public let value: Int
        
        public init(_ value: Int) {
            if value < Self.smallestPossibleRatingValue {
                self.value = Self.smallestPossibleRatingValue
            } else if value > Self.largestPossibleRatingValue {
                self.value = Self.largestPossibleRatingValue
            } else {
                self.value = value
            }
        }
        
        public init(integerLiteral value: IntegerLiteralType) {
            self.init(value)
        }
        
    }
    
    /// Prepares an object to collect feedback for the receiver.
    ///
    /// Attempting to prepare feedback for an event that is not accepting feedback throws an error.
    ///
    /// - Returns: A `FeedbackForm` for collating and submitting feedback.
    public func prepareFeedback() throws -> FeedbackForm {
        guard let api = managedObjectContext?.eurofurenceAPI, acceptingFeedback else {
            throw EurofurenceError.eventNotAcceptingFeedback(identifier)
        }
        
        return FeedbackForm(event: self, api: api)
    }
    
}

// MARK: - Calendar Management

extension Event {
    
    /// Adds the receiver to the device calendar.
    public func addToCalendar() {
        guard isPresentInCalendar == false else { return }
        eventsCalendar.add(entry: calendarEntry)
    }
    
    public func removeFromCalendar() {
        eventsCalendar.remove(entry: calendarEntry)
    }
    
    private func listenForCalendarChanges() {
        eventsCalendar
            .calendarChanged
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    private var calendarEntry: EventCalendarEntry {
        EventCalendarEntry(
            title: calendarEntryTitle,
            startDate: startDate,
            endDate: endDate,
            location: room.name,
            shortDescription: abstract ?? "",
            url: eurofurenceAPI.url(for: .event(id: identifier))
        )
    }
    
    private var calendarEntryTitle: String {
        if tags.contains(where: { $0.name == "essential_subtitle" }) {
            return "\(title) - \(subtitle)"
        } else {
            return title
        }
    }
    
}

// MARK: - Event + ConsumesRemoteResponse

extension Event: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Event
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        slug = context.remoteObject.slug
        title = context.remoteObject.title
        subtitle = context.remoteObject.subtitle
        abstract = context.remoteObject.abstract
        deviatingFromConbook = context.remoteObject.isDeviatingFromConBook
        acceptingFeedback = context.remoteObject.isAcceptingFeedback
        eventDescription = context.remoteObject.description
        startDate = context.remoteObject.startDateTimeUtc
        endDate = context.remoteObject.endDateTimeUtc
        
        day = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.dayIdentifier)
        room = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.roomIdentifier)
        track = try context.managedObjectContext.entity(withIdentifier: context.remoteObject.trackIdentifier)
                
        updateTags(context)
        updateHosts(context)
        updateBanner(context)
        updatePoster(context)
    }
    
    private func updateTags(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        for remoteTag in context.remoteObject.tags {
            let tag = Tag.named(name: remoteTag, in: context.managedObjectContext)
            addToTags(tag)
        }
    }
    
    private func updateHosts(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        let hosts = context.remoteObject.panelHostsSeperatedByComma.components(separatedBy: ",")
        for host in hosts {
            let trimmedHost = host.trimmingCharacters(in: .whitespaces)
            let host = PanelHost.named(name: trimmedHost, in: context.managedObjectContext)
            addToPanelHosts(host)
        }
    }
    
    private func updateBanner(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        let bannerID = context.remoteObject.bannerImageIdentifier
        if let bannerID = bannerID, let remoteBanner = context.image(identifiedBy: bannerID) {
            let eventBanner = EventBanner.identifiedBy(identifier: bannerID, in: context.managedObjectContext)
            eventBanner.update(from: remoteBanner)
            
            banner = eventBanner
        }
    }
    
    private func updatePoster(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        let posterID = context.remoteObject.posterImageIdentifier
        if let posterID = posterID, let remotePoster = context.image(identifiedBy: posterID) {
            let eventPoster = EventPoster.identifiedBy(identifier: posterID, in: context.managedObjectContext)
            eventPoster.update(from: remotePoster)
            
            poster = eventPoster
        }
    }
    
}

// MARK: - Predicates

extension Event {
    
    static func predicate(forEventsOccurringOn day: Day) -> NSPredicate {
        NSPredicate(format: "SELF.day == %@", day)
    }
    
    static func predicate(forEventsInTrack track: Track) -> NSPredicate {
        NSPredicate(format: "SELF.track == %@", track)
    }
    
    static func predicate(forEventsInRoom room: Room) -> NSPredicate {
        NSPredicate(format: "SELF.room == %@", room)
    }
    
    static func predicateForTextualSearch(query: String) -> NSPredicate {
        NSPredicate(format: "SELF.title CONTAINS[c] %@", query)
    }
    
}

// MARK: - Core Data Generated Accessors

extension Event {
    
    // MARK: Panel Hosts

    @objc(addPanelHostsObject:)
    @NSManaged func addToPanelHosts(_ value: PanelHost)

    @objc(removePanelHostsObject:)
    @NSManaged func removeFromPanelHosts(_ value: PanelHost)

    @objc(addPanelHosts:)
    @NSManaged func addToPanelHosts(_ values: Set<PanelHost>)

    @objc(removePanelHosts:)
    @NSManaged func removeFromPanelHosts(_ values: Set<PanelHost>)

    // MARK: Tags

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
