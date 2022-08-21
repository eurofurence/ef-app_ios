import EurofurenceModel
import Foundation
import ScheduleComponent
import TestUtilities
import XCTEurofurenceModel

public final class CapturingScheduleViewModel: ScheduleViewModel {

    public var days: [ScheduleDayViewModel]
    public var events: [ScheduleEventGroupViewModel]
    public var currentDay: Int

    public init(days: [ScheduleDayViewModel], events: [ScheduleEventGroupViewModel], currentDay: Int) {
        self.days = days
        self.events = events
        self.currentDay = currentDay
    }

    public private(set) var delegate: ScheduleViewModelDelegate?
    public func setDelegate(_ delegate: ScheduleViewModelDelegate) {
        self.delegate = delegate
        delegate.scheduleViewModelDidUpdateDays(days)
        delegate.scheduleViewModelDidUpdateEvents(events)
        delegate.scheduleViewModelDidUpdateCurrentDayIndex(to: currentDay)
    }

    public private(set) var didPerformRefresh = false
    public func refresh() {
        didPerformRefresh = true
    }

    public private(set) var capturedDayToShowIndex: Int?
    public func showEventsForDay(at index: Int) {
        capturedDayToShowIndex = index
    }

    fileprivate var stubbedIdentifiersByIndexPath = [IndexPath: EventIdentifier]()
    public func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier? {
        return stubbedIdentifiersByIndexPath[indexPath]
    }

    public private(set) var toldToFilterToFavouritesOnly = false
    func onlyShowFavourites() {
        toldToFilterToFavouritesOnly = true
    }

    public private(set) var toldToShowAllEvents = false
    func showAllEvents() {
        toldToShowAllEvents = true
    }

    public private(set) var indexPathForFavouritedEvent: IndexPath?
    func favouriteEvent(at indexPath: IndexPath) {
        indexPathForFavouritedEvent = indexPath
    }

    public private(set) var indexPathForUnfavouritedEvent: IndexPath?
    func unfavouriteEvent(at indexPath: IndexPath) {
        indexPathForUnfavouritedEvent = indexPath
    }
    
    public private(set) var didToggleFavouriteFilteringState = false
    public func toggleFavouriteFilteringState() {
        didToggleFavouriteFilteringState = true
    }

}

extension CapturingScheduleViewModel {

    public func eventViewModel(inGroup group: Int, at index: Int) -> StubScheduleEventViewModel {
        guard let viewModel = events[group].events[index] as? StubScheduleEventViewModel else {
            fatalError("Expected \(StubScheduleEventViewModel.self)")
        }
        
        return viewModel
    }

    public func stub(_ identifier: EventIdentifier, at indexPath: IndexPath) {
        stubbedIdentifiersByIndexPath[indexPath] = identifier
    }

    public func simulateScheduleRefreshDidBegin() {
        delegate?.scheduleViewModelDidBeginRefreshing()
    }

    public func simulateScheduleRefreshDidFinish() {
        delegate?.scheduleViewModelDidFinishRefreshing()
    }
    
    public func simulateShowingFavourites() {
        delegate?.scheduleViewModelDidFilterToFavourites()
    }
    
    public func simulateShowingAllEvents() {
        delegate?.scheduleViewModelDidRemoveFavouritesFilter()
    }

}
