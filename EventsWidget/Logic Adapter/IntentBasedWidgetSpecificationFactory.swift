import EurofurenceApplicationSession
import EurofurenceIntentDefinitions
import EurofurenceModel

struct IntentBasedWidgetSpecificationFactory {
    
    private static let upcomingEventsConfiguration = RemotelyConfiguredUpcomingEventsConfiguration()
    
    static func makeSpecification(intent: ViewEventsIntent, clock: Clock) -> AnySpecification<EurofurenceModel.Event> {
        let favouritesOnly = intent.favouritesOnly?.boolValue ?? false
        
        switch intent.filter {
        case .running:
            return RunningEventSpecification(clock: clock)
                .enableFavoritesOnlyFilter(favouritesOnly)
            
        default:
            return UpcomingEventSpecification(clock: clock, configuration: upcomingEventsConfiguration)
                .enableFavoritesOnlyFilter(favouritesOnly)
        }
    }
    
    static func makeEntryTimeOffset(intent: ViewEventsIntent) -> TimeInterval {
        switch intent.filter {
        case .upcoming:
            return upcomingEventsConfiguration.intervalFromPresentForUpcomingEvents
            
        default:
            return 0
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
