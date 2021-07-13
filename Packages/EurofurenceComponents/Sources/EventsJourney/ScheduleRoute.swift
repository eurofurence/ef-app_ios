import RouterCore
import ScheduleComponent

public struct ScheduleRoute: Route {
    
    private let presentation: SchedulePresentation
    
    public init(presentation: SchedulePresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: ScheduleRouteable) {
        presentation.showSchedule()
    }
    
}
