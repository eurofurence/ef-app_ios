import EurofurenceModel
import KnowledgeDetailComponent
import UIKit.UIViewController

class StubKnowledgeDetailSceneFactory: KnowledgeDetailSceneFactory {

    let interface = CapturingKnowledgeDetailScene()
    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene {
        return interface
    }

}
