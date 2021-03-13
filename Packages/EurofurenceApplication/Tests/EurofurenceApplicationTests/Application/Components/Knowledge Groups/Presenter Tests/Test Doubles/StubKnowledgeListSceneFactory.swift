import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController

struct StubKnowledgeListSceneFactory: KnowledgeListSceneFactory {

    let scene = CapturingKnowledgeListScene()
    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene {
        return scene
    }

}
