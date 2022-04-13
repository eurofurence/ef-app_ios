import EurofurenceApplication
import RouterCore

struct FakeEventsWidgetViewModelFactory: NewsWidgetViewModelFactory {
    
    let viewModel: FakeEventsWidgetViewModel
    
    func makeViewModel(router: Router) -> some EventsWidgetViewModel {
        viewModel
    }
    
}
