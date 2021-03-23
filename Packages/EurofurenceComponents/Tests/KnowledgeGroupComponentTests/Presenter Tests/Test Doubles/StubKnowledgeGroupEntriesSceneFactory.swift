import EurofurenceModel
import KnowledgeGroupComponent
import UIKit

class StubKnowledgeGroupEntriesSceneFactory: KnowledgeGroupEntriesSceneFactory {

    let scene = CapturingKnowledgeGroupEntriesScene()
    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene {
        return scene
    }

}
