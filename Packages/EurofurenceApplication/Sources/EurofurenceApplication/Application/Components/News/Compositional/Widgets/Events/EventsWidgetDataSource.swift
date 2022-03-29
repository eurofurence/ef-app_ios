import Combine
import EurofurenceModel

public protocol EventsWidgetDataSource {
    
    associatedtype Publisher: Combine.Publisher where Publisher.Output == [Event], Publisher.Failure == Never
    
    var events: Publisher { get }
    
}
