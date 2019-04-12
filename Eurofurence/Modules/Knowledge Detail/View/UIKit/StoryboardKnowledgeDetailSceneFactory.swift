import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardKnowledgeDetailSceneFactory: KnowledgeDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeDetail", bundle: .main)

    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene {
        return storyboard.instantiate(KnowledgeDetailViewController.self)
    }

}
