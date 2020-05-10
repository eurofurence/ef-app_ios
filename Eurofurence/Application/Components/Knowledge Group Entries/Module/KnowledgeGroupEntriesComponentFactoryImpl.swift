import EurofurenceModel
import Foundation
import UIKit

struct KnowledgeGroupEntriesComponentFactoryImpl: KnowledgeGroupEntriesComponentFactory {

    var knowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory
    var sceneFactory: KnowledgeGroupEntriesSceneFactory

    func makeKnowledgeGroupEntriesModule(
        _ groupIdentifier: KnowledgeGroupIdentifier,
        delegate: KnowledgeGroupEntriesComponentDelegate
    ) -> UIViewController {
        let scene = sceneFactory.makeKnowledgeGroupEntriesScene()
        _ = KnowledgeGroupEntriesPresenter(
            scene: scene,
            knowledgeGroupViewModelFactory: knowledgeGroupViewModelFactory,
            groupIdentifier: groupIdentifier,
            delegate: delegate
        )

        return scene
    }

}
