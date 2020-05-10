import UIKit

struct ScheduleContentControllerFactory: ApplicationModuleFactory {
    
    var scheduleModuleProviding: ScheduleModuleProviding
    var scheduleModuleDelegate: ScheduleModuleDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        scheduleModuleProviding.makeScheduleModule(scheduleModuleDelegate)
    }
    
}
