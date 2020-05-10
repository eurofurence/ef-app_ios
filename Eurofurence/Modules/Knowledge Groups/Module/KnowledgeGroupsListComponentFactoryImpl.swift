import UIKit.UIViewController

struct KnowledgeGroupsListComponentFactoryImpl: KnowledgeGroupsListComponentFactory {

    var knowledgeSceneFactory: KnowledgeListSceneFactory
    var knowledgeListInteractor: KnowledgeGroupsViewModelFactory

    func makeKnowledgeListComponent(_ delegate: KnowledgeGroupsListComponentDelegate) -> UIViewController {
        let scene = knowledgeSceneFactory.makeKnowledgeListScene()
        let presenter = KnowledgeGroupsListPresenter(
            scene: scene,
            knowledgeListInteractor: knowledgeListInteractor,
            delegate: delegate
        )
        
        scene.setDelegate(presenter)

        return scene
    }

}
