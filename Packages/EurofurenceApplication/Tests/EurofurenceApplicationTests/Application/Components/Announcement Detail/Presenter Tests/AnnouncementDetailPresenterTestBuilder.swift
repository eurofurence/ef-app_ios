import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTEurofurenceModel

class AnnouncementDetailPresenterTestBuilder {

    struct Context {
        var announcementDetailScene: UIViewController
        var sceneFactory: StubAnnouncementDetailSceneFactory
        var scene: CapturingAnnouncementDetailScene
        var announcementViewModel: AnnouncementDetailViewModel
    }

    func build() -> Context {
        let sceneFactory = StubAnnouncementDetailSceneFactory()
        let announcement: FakeAnnouncement = .random
        let announcementDetailViewModelFactory = StubAnnouncementDetailViewModelFactory(for: announcement.identifier)
        let module = AnnouncementDetailComponentBuilder(
            announcementDetailViewModelFactory: announcementDetailViewModelFactory
        )
        .with(sceneFactory)
        .build()
        .makeAnnouncementDetailModule(for: announcement.identifier)
        
        return Context(announcementDetailScene: module,
                       sceneFactory: sceneFactory,
                       scene: sceneFactory.stubbedScene,
                       announcementViewModel: announcementDetailViewModelFactory.viewModel)
    }

}

extension AnnouncementDetailPresenterTestBuilder.Context {

    func simulateAnnouncementDetailSceneDidLoad() {
        scene.delegate?.announcementDetailSceneDidLoad()
    }

}
