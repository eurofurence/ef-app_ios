import EurofurenceModel

struct EventFeedbackPresenter: EventFeedbackSceneDelegate {
    
    private let event: Event
    private let scene: EventFeedbackScene
    private let delegate: EventFeedbackModuleDelegate
    private let dayOfWeekFormatter: DayOfWeekFormatter
    private let startTimeFormatter: HoursDateFormatter
    private let endTimeFormatter: HoursDateFormatter
    
    init(event: Event,
         scene: EventFeedbackScene,
         delegate: EventFeedbackModuleDelegate,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter) {
        self.event = event
        self.scene = scene
        self.delegate = delegate
        self.dayOfWeekFormatter = dayOfWeekFormatter
        self.startTimeFormatter = startTimeFormatter
        self.endTimeFormatter = endTimeFormatter
        
        scene.setDelegate(self)
    }
    
    func eventFeedbackSceneDidLoad() {
        let viewModel = ViewModel(event: event,
                                  delegate: delegate,
                                  dayOfWeekFormatter: dayOfWeekFormatter,
                                  startTimeFormatter: startTimeFormatter,
                                  endTimeFormatter: endTimeFormatter)
        scene.bind(viewModel)
    }
    
    private class ViewModel: EventFeedbackViewModel {
        
        private var eventFeedback: EventFeedback
        private let delegate: EventFeedbackModuleDelegate
        
        var eventTitle: String
        var eventDayAndTime: String
        var eventLocation: String
        var eventHosts: String

        init(event: Event,
             delegate: EventFeedbackModuleDelegate,
             dayOfWeekFormatter: DayOfWeekFormatter,
             startTimeFormatter: HoursDateFormatter,
             endTimeFormatter: HoursDateFormatter) {
            let dayAndTime: String = {
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
            
            self.delegate = delegate
            eventFeedback = event.prepareFeedback()
            eventTitle = event.title
            eventDayAndTime = dayAndTime
            eventLocation = event.room.name
            eventHosts = hosts
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
        
        func cancelFeedback() {
            delegate.eventFeedbackDismissed()
        }
        
    }
    
}
