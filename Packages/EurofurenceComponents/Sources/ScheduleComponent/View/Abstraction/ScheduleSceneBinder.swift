import ComponentBase
import Foundation

public protocol ScheduleSceneBinder {

    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int)
    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath)
    func eventActionsForComponent(at indexPath: IndexPath) -> ContextualCommands

}
