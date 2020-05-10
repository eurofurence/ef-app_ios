import Foundation

protocol ScheduleSceneBinder {

    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int)
    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath)
    func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction

}

struct ScheduleEventComponentAction {
    var title: String
    var run: () -> Void
}
