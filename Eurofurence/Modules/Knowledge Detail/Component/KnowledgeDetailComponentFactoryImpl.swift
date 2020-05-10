import EurofurenceModel
import UIKit.UIViewController

struct KnowledgeDetailComponentFactoryImpl: KnowledgeDetailComponentFactory {

    var knowledgeDetailSceneFactory: KnowledgeDetailSceneFactory
    var knowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory

    func makeKnowledgeListModule(
        _ identifier: KnowledgeEntryIdentifier,
        delegate: KnowledgeDetailComponentDelegate
    ) -> UIViewController {
        let scene = knowledgeDetailSceneFactory.makeKnowledgeDetailScene()
        _ = KnowledgeDetailPresenter(
            delegate: delegate,
            knowledgeDetailScene: scene,
            identifier: identifier,
            knowledgeDetailViewModelFactory: knowledgeDetailViewModelFactory
        )

        return scene
    }

}
