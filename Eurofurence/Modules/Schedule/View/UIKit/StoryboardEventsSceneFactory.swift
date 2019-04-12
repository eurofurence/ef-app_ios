import UIKit

struct StoryboardScheduleSceneFactory: ScheduleSceneFactory {

    private let storyboard = UIStoryboard(name: "Schedule", bundle: .main)

    func makeEventsScene() -> UIViewController & ScheduleScene {
        return storyboard.instantiate(ScheduleViewController.self)
    }

}
