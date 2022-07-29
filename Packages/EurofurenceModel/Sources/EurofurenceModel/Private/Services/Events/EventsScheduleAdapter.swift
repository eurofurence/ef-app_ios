import Foundation

class EventsScheduleAdapter: Schedule, CustomStringConvertible {

    private let tag: String
    private let schedule: ConcreteScheduleRepository
    private let clock: Clock
    private var events = [EurofurenceModel.Event]()
    private var days = [Day]()
    private var currentDay: Day? {
        didSet {
            delegate?.currentEventDayDidChange(to: currentDay)
        }
    }

    private class UpdateCurrentDayWhenTimePasses: EventConsumer {

        private weak var scheduleAdapter: EventsScheduleAdapter?

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            scheduleAdapter?.updateCurrentDay()
        }

    }

    private class UpdateAdapterWhenScheduleChanges: EventConsumer {

        private weak var scheduleAdapter: EventsScheduleAdapter?

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }

        func consume(event: DomainEvent.EventsChanged) {
            scheduleAdapter?.updateFromSchedule()
        }

    }
    
    private class UpdateAdapterWhenEventFavourited: EventConsumer {
        
        private weak var scheduleAdapter: EventsScheduleAdapter?

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }
        
        func consume(event: DomainEvent.EventAddedToFavourites) {
            scheduleAdapter?.updateFromSchedule()
        }
        
    }
    
    private class UpdateAdapterWhenEventUnfavourited: EventConsumer {
        
        private weak var scheduleAdapter: EventsScheduleAdapter?

        init(scheduleAdapter: EventsScheduleAdapter) {
            self.scheduleAdapter = scheduleAdapter
        }
        
        func consume(event: DomainEvent.EventRemovedFromFavourites) {
            scheduleAdapter?.updateFromSchedule()
        }
        
    }
    
    private var subscriptions = Set<AnyHashable>()

    init(tag: String, schedule: ConcreteScheduleRepository, clock: Clock, eventBus: EventBus) {
        self.tag = tag
        self.schedule = schedule
        self.clock = clock
        events = schedule.eventModels
        days = schedule.dayModels

        subscriptions.insert(eventBus.subscribe(consumer: UpdateAdapterWhenScheduleChanges(scheduleAdapter: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UpdateCurrentDayWhenTimePasses(scheduleAdapter: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UpdateAdapterWhenEventFavourited(scheduleAdapter: self)))
        subscriptions.insert(eventBus.subscribe(consumer: UpdateAdapterWhenEventUnfavourited(scheduleAdapter: self)))
        regenerateSchedule()
        updateCurrentDay()
    }
    
    var description: String {
        tag
    }
    
    func loadEvent(identifier: EventIdentifier) -> Event? {
        schedule.eventModels.first(where: { $0.identifier == identifier })
    }

    private var delegate: ScheduleDelegate?
    func setDelegate(_ delegate: ScheduleDelegate) {
        self.delegate = delegate

        delegate.scheduleEventsDidChange(to: events)
        updateDelegateWithAllDays()
        delegate.currentEventDayDidChange(to: currentDay)
    }

    func restrictEvents(to day: Day) {
        
    }
    
    private var specification: AnySpecification<Event>?
    
    func filterSchedule<S>(to specification: S) where S: Specification, S.Element == Event {
        self.specification = specification.eraseToAnySpecification()
        
        events = schedule.eventModels.filter(specification.isSatisfied(by:))
        delegate?.scheduleEventsDidChange(to: events)
    }

    private func updateCurrentDay() {
        if let day = findDay(for: clock.currentDate) {
            let conferenceDay = Day(date: day.date)
            if conferenceDay != currentDay {
                currentDay = conferenceDay
            }
        } else {
            currentDay = nil
        }
    }

    private func regenerateSchedule() {
        let previousResults = events.map(\.identifier)
        
        var allEvents = schedule.eventModels
        if let specification = specification {
            allEvents = allEvents.filter(specification.isSatisfied(by:))
        }
        
        events = allEvents.sorted(by: { $0.startDate < $1.startDate })
        let newResults = events.map(\.identifier)
        
        guard previousResults != newResults else { return }
        
        delegate?.scheduleEventsDidChange(to: events)
    }

    private func findDay(for date: Date) -> ConferenceDayCharacteristics? {
        let dateOnlyComponents = resolveDateOnlyComponents(from: date)

        return schedule.days.first { (day) in
            let dayComponents = resolveDateOnlyComponents(from: day.date)
            return dayComponents == dateOnlyComponents
        }
    }

    private func resolveDateOnlyComponents(from date: Date) -> DateComponents {
        let dateCalendarComponents: Set<Calendar.Component> = Set([.day, .month, .year])
        let calendar = Calendar.current
        return calendar.dateComponents(dateCalendarComponents, from: date)
    }

    private func updateDelegateWithAllDays() {
        delegate?.eventDaysDidChange(to: schedule.dayModels)
    }

    private func updateFromSchedule() {
        regenerateSchedule()

        if days != schedule.dayModels {
            self.days = schedule.dayModels
            updateDelegateWithAllDays()
            updateCurrentDay()
        }
    }

}
