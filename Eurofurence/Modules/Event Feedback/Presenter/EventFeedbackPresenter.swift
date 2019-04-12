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
        
        let hosts: String = {
            let formatString = String.eventHostedByFormat
            return String.localizedStringWithFormat(formatString, event.hosts)
        }()
        
        let viewModel = ViewModel(eventTitle: event.title,
                                  eventDayAndTime: eventDayAndTime,
                                  eventLocation: event.room.name,
                                  eventHosts: hosts)
        scene.bind(viewModel)
    }
    
    private struct ViewModel: EventFeedbackViewModel {
        
        var eventTitle: String
        var eventDayAndTime: String
        var eventLocation: String
        var eventHosts: String
        
    }
    
}
