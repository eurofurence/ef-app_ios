import EurofurenceModel
import Foundation

protocol ScheduleViewModel {

    func setDelegate(_ delegate: ScheduleViewModelDelegate)
    func refresh()
    func showEventsForDay(at index: Int)
    func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier?

}

protocol ScheduleViewModelDelegate {

    func scheduleViewModelDidBeginRefreshing()
    func scheduleViewModelDidFinishRefreshing()
    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel])
    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int)
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel])

}
