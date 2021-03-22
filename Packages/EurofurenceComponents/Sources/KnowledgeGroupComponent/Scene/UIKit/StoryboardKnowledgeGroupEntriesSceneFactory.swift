import ComponentBase
import UIKit

struct StoryboardKnowledgeGroupEntriesSceneFactory: KnowledgeGroupEntriesSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeGroupEntries", bundle: .module)

    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene {
        return storyboard.instantiate(KnowledgeGroupEntriesViewController.self)
    }

}
