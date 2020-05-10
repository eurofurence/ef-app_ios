import UIKit.UIViewController

protocol ScheduleComponentFactory {

    func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController

}
