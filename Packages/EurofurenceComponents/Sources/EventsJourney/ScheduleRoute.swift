import ComponentBase
import ScheduleComponent

public struct ScheduleRoute: ContentRoute {
    
    private let presentation: SchedulePresentation
    
    public init(presentation: SchedulePresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: ScheduleContentRepresentation) {
        presentation.showSchedule()
    }
    
}
