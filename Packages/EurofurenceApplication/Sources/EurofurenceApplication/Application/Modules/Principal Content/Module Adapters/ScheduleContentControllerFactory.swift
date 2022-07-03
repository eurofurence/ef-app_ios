import ScheduleComponent
import UIKit

struct ScheduleContentControllerFactory: ApplicationModuleFactory {
    
    var scheduleComponentFactory: ScheduleComponentFactory
    var scheduleComponentDelegate: ScheduleComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        let viewController = scheduleComponentFactory.makeScheduleComponent(scheduleComponentDelegate)
        viewController.tabBarItem.image = UIImage(systemName: "calendar", compatibleWith: nil)
        
        return viewController
    }
    
}
