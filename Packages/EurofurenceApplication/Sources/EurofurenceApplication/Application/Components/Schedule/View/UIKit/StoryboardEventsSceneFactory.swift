import UIKit

struct StoryboardScheduleSceneFactory: ScheduleSceneFactory {

    private let storyboard = UIStoryboard(name: "Schedule", bundle: .module)

    func makeEventsScene() -> UIViewController & ScheduleScene {
        return storyboard.instantiate(ScheduleViewController.self)
    }

}
