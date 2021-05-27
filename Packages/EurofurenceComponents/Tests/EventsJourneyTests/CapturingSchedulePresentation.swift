import EventsJourney

class CapturingSchedulePresentation: SchedulePresentation {
    
    private(set) var didShowSchedule = false
    func showSchedule() {
        didShowSchedule = true
    }
    
}
