import EurofurenceModel
import Foundation
import ScheduleComponent

class CapturingScheduleViewModelDelegate: ScheduleViewModelDelegate {

    private(set) var viewModelDidBeginRefreshing = false
    func scheduleViewModelDidBeginRefreshing() {
        viewModelDidBeginRefreshing = true
    }

    private(set) var viewModelDidFinishRefreshing = false
    func scheduleViewModelDidFinishRefreshing() {
        viewModelDidFinishRefreshing = true
    }

    private(set) var daysViewModels: [ScheduleDayViewModel] = []
    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        daysViewModels = days
    }

    private(set) var currentDayIndex: Int?
    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int) {
        currentDayIndex = index
    }

    private(set) var eventsViewModels: [ScheduleEventGroupViewModel] = []
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        eventsViewModels = events
    }
    
    enum FavouritesFilter: Equatable {
        case unset
        case favouritesOnly
        case allEvents
    }
    
    private(set) var favouritesfilter: FavouritesFilter = .unset
    func scheduleViewModelDidFilterToFavourites() {
        favouritesfilter = .favouritesOnly
    }
    
    func scheduleViewModelDidRemoveFavouritesFilter() {
        favouritesfilter = .allEvents
    }

}
