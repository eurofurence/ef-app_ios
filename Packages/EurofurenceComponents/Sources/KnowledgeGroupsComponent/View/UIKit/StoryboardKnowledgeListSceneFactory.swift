import UIKit

struct StoryboardKnowledgeListSceneFactory: KnowledgeListSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeList", bundle: .module)

    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene {
        return storyboard.instantiate(KnowledgeListViewController.self)
    }

}
