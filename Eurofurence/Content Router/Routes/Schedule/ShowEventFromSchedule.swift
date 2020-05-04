import EurofurenceModel

public struct ShowEventFromSchedule: ScheduleModuleDelegate {
    
    private let router: ContentRouter
    
    public init(router: ContentRouter) {
        self.router = router
    }
    
    public func scheduleModuleDidSelectEvent(identifier: EventIdentifier) {
        try? router.route(EventContentRepresentation(identifier: identifier))
    }
    
}
