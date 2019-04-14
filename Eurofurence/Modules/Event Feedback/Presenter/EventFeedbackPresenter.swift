import EurofurenceModel

struct EventFeedbackPresenter: EventFeedbackSceneDelegate {
    
    private let event: Event
    private let scene: EventFeedbackScene
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    
    init(event: Event,
         scene: EventFeedbackScene,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter) {
        self.event = event
        self.scene = scene
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
        
        scene.setDelegate(self)
    }
    
    func eventFeedbackSceneDidLoad() {
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
