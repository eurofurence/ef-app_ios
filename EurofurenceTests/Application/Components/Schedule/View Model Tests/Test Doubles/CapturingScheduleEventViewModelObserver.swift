@testable import Eurofurence

class CapturingScheduleEventViewModelObserver: ScheduleEventViewModelObserver {
    
    enum State {
        case unset
        case favourited
        case unfavourited
    }
    
    private(set) var state: State = .unset
    
    func eventViewModelDidBecomeFavourite(_ viewModel: ScheduleEventViewModelProtocol) {
        state = .favourited
    }
    
    func eventViewModelDidBecomeNonFavourite(_ viewModel: ScheduleEventViewModelProtocol) {
        state = .unfavourited
    }
    
}
