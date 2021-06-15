import ScheduleComponent
import UIKit

public struct StubScheduleComponentFactory: ScheduleComponentFactory {
    
    public init() {
        
    }
    
    public let component = UIViewController()
    public func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController {
        return component
    }
    
}
