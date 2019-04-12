import EurofurenceModel

struct EventFeedbackPresenter {
    
    init(event: Event,
         scene: EventFeedbackScene,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter) {
        let eventDayAndTime: String = {
            let eventDayOfTheWeek = dayOfWeekFormatter.formatDayOfWeek(from: event.startDate)
            let eventStartTime = startTimeFormatter.hoursString(from: event.startDate)
            let eventEndTime = endTimeFormatter.hoursString(from: event.endDate)
            let eventDayAndTimeFormat = String.eventFeedbackDayAndTimeFormat
            
            return String.localizedStringWithFormat(eventDayAndTimeFormat, eventDayOfTheWeek, eventStartTime, eventEndTime)
        }()
        
        let viewModel = ViewModel(eventTitle: event.title, eventDayAndTime: eventDayAndTime)
        scene.bind(viewModel)
    }
    
    private struct ViewModel: EventFeedbackViewModel {
        
        var eventTitle: String
        var eventDayAndTime: String
        
    }
    
}
