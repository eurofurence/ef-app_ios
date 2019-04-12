import UIKit.UIViewController

protocol ScheduleModuleProviding {

    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController

}
