import UIKit.UIViewController

struct KnowledgeListModule: KnowledgeGroupsListModuleProviding {

    var knowledgeSceneFactory: KnowledgeListSceneFactory
    var knowledgeListInteractor: KnowledgeGroupsInteractor

    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController {
        let scene = knowledgeSceneFactory.makeKnowledgeListScene()
        let presenter = KnowledgeGroupsListPresenter(scene: scene,
                                               knowledgeListInteractor: knowledgeListInteractor,
                                               delegate: delegate)
        scene.setDelegate(presenter)

        return scene
    }

}
