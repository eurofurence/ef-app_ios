@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class AnnouncementDetailPresenterTestBuilder {

    struct Context {
        var announcementDetailScene: UIViewController
        var sceneFactory: StubAnnouncementDetailSceneFactory
        var scene: CapturingAnnouncementDetailScene
        var announcementViewModel: AnnouncementViewModel
    }

    func build() -> Context {
        let sceneFactory = StubAnnouncementDetailSceneFactory()
        let announcement: StubAnnouncement = .random
        let announcementDetailInteractor = StubAnnouncementDetailInteractor(for: announcement.identifier)
        let module = AnnouncementDetailModuleBuilder(announcementDetailInteractor: announcementDetailInteractor)
            .with(sceneFactory)
            .build()
            .makeAnnouncementDetailModule(for: announcement.identifier)

        return Context(announcementDetailScene: module,
                       sceneFactory: sceneFactory,
                       scene: sceneFactory.stubbedScene,
                       announcementViewModel: announcementDetailInteractor.viewModel)
    }

}

extension AnnouncementDetailPresenterTestBuilder.Context {

    func simulateAnnouncementDetailSceneDidLoad() {
        scene.delegate?.announcementDetailSceneDidLoad()
    }

}
