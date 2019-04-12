import UIKit.UIViewController

protocol ScheduleSceneFactory {

    func makeEventsScene() -> UIViewController & ScheduleScene

}
