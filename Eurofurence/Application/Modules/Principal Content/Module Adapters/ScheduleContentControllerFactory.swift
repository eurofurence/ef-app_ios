import UIKit

struct ScheduleContentControllerFactory: ApplicationModuleFactory {
    
    var scheduleComponentFactory: ScheduleComponentFactory
    var scheduleComponentDelegate: ScheduleComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        scheduleComponentFactory.makeScheduleComponent(scheduleComponentDelegate)
    }
    
}
