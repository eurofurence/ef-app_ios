import UIKit.UIViewController

public protocol ScheduleComponentFactory {

    func makeScheduleComponent(_ delegate: ScheduleComponentDelegate) -> UIViewController

}
