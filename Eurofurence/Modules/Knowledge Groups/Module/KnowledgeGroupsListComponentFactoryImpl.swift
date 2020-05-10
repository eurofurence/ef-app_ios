import UIKit.UIViewController

struct KnowledgeGroupsListComponentFactoryImpl: KnowledgeGroupsListComponentFactory {

    var knowledgeSceneFactory: KnowledgeListSceneFactory
    var knowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory

    func makeKnowledgeListComponent(_ delegate: KnowledgeGroupsListComponentDelegate) -> UIViewController {
        let scene = knowledgeSceneFactory.makeKnowledgeListScene()
        let presenter = KnowledgeGroupsListPresenter(
            scene: scene,
            knowledgeGroupsViewModelFactory: knowledgeGroupsViewModelFactory,
            delegate: delegate
        )
        
        scene.setDelegate(presenter)

        return scene
    }

}
