@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class CapturingAnnouncementsComponentDelegate: AnnouncementsComponentDelegate {

    private(set) var capturedSelectedAnnouncement: AnnouncementIdentifier?
    func announcementsComponentDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        capturedSelectedAnnouncement = announcement
    }

}

class AnnouncementsPresenterTestBuilder {

    struct Context {
        var scene: CapturingAnnouncementsScene
        var producedViewController: UIViewController
        var delegate: CapturingAnnouncementsComponentDelegate
    }

    private var announcementsViewModelFactory: AnnouncementsViewModelFactory

    init() {
        announcementsViewModelFactory = FakeAnnouncementsViewModelFactory()
    }

    @discardableResult
    func with(_ announcementsViewModelFactory: AnnouncementsViewModelFactory) -> AnnouncementsPresenterTestBuilder {
        self.announcementsViewModelFactory = announcementsViewModelFactory
        return self
    }

    func build() -> Context {
        let sceneFactory = StubAnnouncementsSceneFactory()
        let delegate = CapturingAnnouncementsComponentDelegate()
        let module = AnnouncementsComponentBuilder(announcementsViewModelFactory: announcementsViewModelFactory)
            .with(sceneFactory)
            .build()
            .makeAnnouncementsComponent(delegate)

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
