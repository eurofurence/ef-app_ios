import EurofurenceModel

struct EventFeedbackPresenter {
    
    init(event: Event, scene: EventFeedbackScene) {
        let viewModel = ViewModel(eventTitle: event.title)
        scene.bind(viewModel)
    }
    
    private struct ViewModel: EventFeedbackViewModel {
        
        var eventTitle: String
        
    }
    
}
