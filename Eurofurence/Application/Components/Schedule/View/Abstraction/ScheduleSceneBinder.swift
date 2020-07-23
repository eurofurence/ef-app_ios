import Foundation

public protocol ScheduleSceneBinder {

    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int)
    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath)
    func eventActionsForComponent(at indexPath: IndexPath) -> [ScheduleEventComponentAction]

}

public struct ScheduleEventComponentAction {
    
    public var title: String
    public var run: () -> Void
    
    public init(title: String, run: @escaping () -> Void) {
        self.title = title
        self.run = run
    }
    
}
