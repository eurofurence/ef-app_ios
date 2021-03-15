import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardMessagesSceneFactory: MessagesSceneFactory {

    private let storyboard = UIStoryboard(name: "Messages", bundle: .module)

    func makeMessagesScene() -> UIViewController & MessagesScene {
        return storyboard.instantiate(MessagesViewController.self)
    }

}
