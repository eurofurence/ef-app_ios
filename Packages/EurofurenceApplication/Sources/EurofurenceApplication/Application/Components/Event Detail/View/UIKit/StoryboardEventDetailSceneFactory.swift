import UIKit

struct StoryboardEventDetailSceneFactory: EventDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "EventDetail", bundle: .module)

    func makeEventDetailScene() -> UIViewController & EventDetailScene {
        return storyboard.instantiate(EventDetailViewController.self)
    }

}
