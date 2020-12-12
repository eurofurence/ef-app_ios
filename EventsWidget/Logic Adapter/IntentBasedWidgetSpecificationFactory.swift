import EurofurenceApplicationSession
import EurofurenceIntentDefinitions
import EurofurenceModel

struct IntentBasedWidgetSpecificationFactory {
    
    static func makeSpecification(intent: ViewEventsIntent, clock: Clock) -> AnySpecification<EurofurenceModel.Event> {
        let favouritesOnly = intent.favouritesOnly?.boolValue ?? false
        
        switch intent.filter {
        case .running:
            return RunningEventSpecification(clock: clock)
                .enableFavoritesOnlyFilter(favouritesOnly)
            
        case .upcoming:
            fallthrough
        default:
            return UpcomingEventSpecification(
                clock: clock,
                configuration: RemotelyConfiguredUpcomingEventsConfiguration()
            )
            .enableFavoritesOnlyFilter(favouritesOnly)
        }
    }
    
}

private extension Specification where Element == EurofurenceModel.Event {
    
    func enableFavoritesOnlyFilter(_ enable: Bool) -> AnySpecification<EurofurenceModel.Event> {
        if enable {
            return and(IsFavouriteEventSpecification()).eraseToAnySpecification()
        } else {
            return eraseToAnySpecification()
        }
    }
    
}
