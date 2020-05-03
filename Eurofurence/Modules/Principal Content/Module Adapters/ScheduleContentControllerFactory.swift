import UIKit

struct ScheduleContentControllerFactory: ContentControllerFactory {
    
    var scheduleModuleProviding: ScheduleModuleProviding
    var scheduleModuleDelegate: ScheduleModuleDelegate
    
    func makeContentController() -> UIViewController {
        scheduleModuleProviding.makeScheduleModule(scheduleModuleDelegate)
    }
    
}
