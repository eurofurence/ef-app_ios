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
        
        let viewModel = ViewModel(eventFeedback: event.prepareFeedback(),
                                  eventTitle: event.title,
                                  eventDayAndTime: eventDayAndTime,
                                  eventLocation: event.room.name,
                                  eventHosts: hosts)
        scene.bind(viewModel)
    }
    
    private class ViewModel: EventFeedbackViewModel {
        
        private var eventFeedback: EventFeedback
        
        var eventTitle: String
        var eventDayAndTime: String
        var eventLocation: String
        var eventHosts: String

        init(eventFeedback: EventFeedback, eventTitle: String, eventDayAndTime: String, eventLocation: String, eventHosts: String) {
            self.eventFeedback = eventFeedback
            self.eventTitle = eventTitle
            self.eventDayAndTime = eventDayAndTime
            self.eventLocation = eventLocation
            self.eventHosts = eventHosts
        }
        
        func feedbackChanged(_ feedback: String) {
            eventFeedback.feedback = feedback
        }
        
        func ratingPercentageChanged(_ ratingPercentage: Float) {
            eventFeedback.rating = Int(ratingPercentage * 10) / 2
        }
        
        func submitFeedback() {
            eventFeedback.submit()
        }
        
    }
    
}
