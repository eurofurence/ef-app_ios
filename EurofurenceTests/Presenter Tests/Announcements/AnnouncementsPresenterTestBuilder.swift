@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class CapturingAnnouncementsModuleDelegate: AnnouncementsModuleDelegate {

    private(set) var capturedSelectedAnnouncement: AnnouncementIdentifier?
    func announcementsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        capturedSelectedAnnouncement = announcement
    }

}

class AnnouncementsPresenterTestBuilder {

    struct Context {
        var scene: CapturingAnnouncementsScene
        var producedViewController: UIViewController
        var delegate: CapturingAnnouncementsModuleDelegate
    }

    private var announcementsInteractor: AnnouncementsInteractor

    init() {
        announcementsInteractor = FakeAnnouncementsInteractor()
    }

    @discardableResult
    func with(_ announcementsInteractor: AnnouncementsInteractor) -> AnnouncementsPresenterTestBuilder {
        self.announcementsInteractor = announcementsInteractor
        return self
    }

    func build() -> Context {
        let sceneFactory = StubAnnouncementsSceneFactory()
        let delegate = CapturingAnnouncementsModuleDelegate()
        let module = AnnouncementsModuleBuilder(announcementsInteractor: announcementsInteractor)
            .with(sceneFactory)
            .build()
            .makeAnnouncementsModule(delegate)

        return Context(scene: sceneFactory.scene, producedViewController: module, delegate: delegate)
    }

}

extension AnnouncementsPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.announcementsSceneDidLoad()
    }

    func simulateSceneDidSelectAnnouncement(at index: Int) {
        scene.delegate?.announcementsSceneDidSelectAnnouncement(at: index)
    }

    func bindAnnouncement(at index: Int) -> CapturingAnnouncementComponent {
        let component = CapturingAnnouncementComponent()
        scene.binder?.bind(component, at: index)
        return component
    }

}
