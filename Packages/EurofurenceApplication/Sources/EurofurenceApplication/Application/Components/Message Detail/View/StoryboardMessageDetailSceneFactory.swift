import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardMessageDetailSceneFactory: MessageDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "MessageDetail", bundle: .module)

    func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
        return storyboard.instantiate(MessageDetailViewController.self)
    }

}
