import UIKit.UIViewController

public protocol ScheduleSceneFactory {

    func makeEventsScene() -> UIViewController & ScheduleScene

}
