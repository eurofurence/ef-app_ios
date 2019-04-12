import EurofurenceModel

struct EventFeedbackPresenter {
    
    init(event: Event,
         scene: EventFeedbackScene,
         dayOfWeekFormatter: DayOfWeekFormatter) {
        let eventDayAndTime = dayOfWeekFormatter.formatDayOfWeek(from: event.startDate)
        
        let viewModel = ViewModel(eventTitle: event.title,
                                  eventDayAndTime: eventDayAndTime)
        scene.bind(viewModel)
    }
    
    private struct ViewModel: EventFeedbackViewModel {
        
        var eventTitle: String
        var eventDayAndTime: String
        
    }
    
}
