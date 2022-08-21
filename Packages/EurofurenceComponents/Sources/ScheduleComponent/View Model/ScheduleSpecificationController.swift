import EurofurenceModel

class ScheduleSpecificationController {
    
    private let schedule: Schedule
    private var currentDay: Day?
    private(set) var isFilteringToFavourites = false
    
    init(schedule: Schedule) {
        self.schedule = schedule
    }
    
    func scheduleSpecificationDidChange(newSpecification: AnySpecification<Event>) {
        isFilteringToFavourites = newSpecification.contains(IsFavouriteEventSpecification.self)
    }
    
    func toggleFavouritesFiltering() {
        isFilteringToFavourites.toggle()
        updateScheduleSpecification()
    }
    
    func filterToEvents(occurringOn day: Day?) {
        currentDay = day
        updateScheduleSpecification()
    }
    
    private func updateScheduleSpecification() {
        if let currentDay = currentDay {
            if isFilteringToFavourites {
                let spec = EventsOccurringOnDaySpecification(day: currentDay) && IsFavouriteEventSpecification()
                schedule.filterSchedule(to: spec)
            } else {
                let spec = EventsOccurringOnDaySpecification(day: currentDay)
                schedule.filterSchedule(to: spec)
            }
        } else {
            if isFilteringToFavourites {
                schedule.filterSchedule(to: IsFavouriteEventSpecification())
            } else {
                schedule.filterSchedule(to: AllEventsSpecification())
            }
        }
    }
    
}
