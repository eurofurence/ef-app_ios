import EurofurenceApplication
import EurofurenceModel
import ScheduleComponent
import UIKit.UIViewController
import XCTEurofurenceModel
import XCTScheduleComponent

class CapturingNewsScene: UIViewController, NewsScene {

    var delegate: NewsSceneDelegate?

    private(set) var capturedTitle: String?
    func showNewsTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedComponentsToBind: Int?
    private(set) var capturedNumberOfItemsPerComponentToBind: [Int] = []
    private(set) var capturedBinder: NewsComponentsBinder?
    let componentFactory = StubNewsComponentFactory()
    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder) {
        capturedComponentsToBind = numberOfItemsPerComponent.count
        capturedNumberOfItemsPerComponentToBind = numberOfItemsPerComponent
        capturedBinder = binder
    }

    private(set) var didShowRefreshIndicator = false
    func showRefreshIndicator() {
        didShowRefreshIndicator = true
    }

    private(set) var didHideRefreshIndicator = false
    func hideRefreshIndicator() {
        didHideRefreshIndicator = true
    }

}

class StubNewsComponentFactory: NewsItemComponentFactory {

    typealias Component = AnyObject

    let stubbedCountdownComponent = CapturingConventionCountdownComponent()
    func makeConventionCountdownComponent(
        configuringUsing block: (ConventionCountdownComponent) -> Void
    ) -> StubNewsComponentFactory.Component {
        block(stubbedCountdownComponent)
        return stubbedCountdownComponent
    }

    let stubbedAnnouncementComponent = CapturingAnnouncementComponent()
    func makeAnnouncementComponent(
        configuringUsing block: (AnnouncementItemComponent) -> Void
    ) -> StubNewsComponentFactory.Component {
        block(stubbedAnnouncementComponent)
        return stubbedAnnouncementComponent
    }

    let stubbedAllAnnouncementsComponent = CapturingAllAnnouncementsComponent()
    func makeAllAnnouncementsComponent(
        configuringUsing block: (AllAnnouncementsComponent) -> Void
    ) -> StubNewsComponentFactory.Component {
        block(stubbedAllAnnouncementsComponent)
        return stubbedAllAnnouncementsComponent
    }

    let stubbedEventComponent = CapturingScheduleEventComponent()
    func makeEventComponent(configuringUsing block: (ScheduleEventComponent) -> Void) -> AnyObject {
        block(stubbedEventComponent)
        return stubbedEventComponent
    }

    let stubbedUserWidgetComponent = CapturingUserWidgetComponent()
    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> AnyObject {
        block(stubbedUserWidgetComponent)
        return stubbedUserWidgetComponent
    }

}

class CapturingConventionCountdownComponent: ConventionCountdownComponent {

    private(set) var capturedTimeUntilConvention: String?
    func setTimeUntilConvention(_ timeUntilConvention: String) {
        capturedTimeUntilConvention = timeUntilConvention
    }

}

class CapturingAllAnnouncementsComponent: AllAnnouncementsComponent {

    private(set) var capturedCaption: String?
    func showCaption(_ caption: String) {
        capturedCaption = caption
    }

}

class CapturingUserWidgetComponent: UserWidgetComponent {

    private(set) var capturedPrompt: String?
    func setPrompt(_ prompt: String) {
        capturedPrompt = prompt
    }

    private(set) var capturedDetailedPrompt: String?
    func setDetailedPrompt(_ detailedPrompt: String) {
        capturedDetailedPrompt = detailedPrompt
    }

    private(set) var didShowHighlightedPrompt = false
    func showHighlightedUserPrompt() {
        didShowHighlightedPrompt = true
    }

    private(set) var didHideHighlightedPrompt = false
    func hideHighlightedUserPrompt() {
        didHideHighlightedPrompt = true
    }

    private(set) var didShowStandardPrompt = false
    func showStandardUserPrompt() {
        didShowStandardPrompt = true
    }

    private(set) var didHideStandardPrompt = false
    func hideStandardUserPrompt() {
        didHideStandardPrompt = true
    }

}

// MARK: Test Helpers

extension CapturingNewsScene {

    var stubbedCountdownComponent: CapturingConventionCountdownComponent {
        return componentFactory.stubbedCountdownComponent
    }

    var stubbedAnnouncementComponent: CapturingAnnouncementComponent {
        return componentFactory.stubbedAnnouncementComponent
    }

    var stubbedAllAnnouncementsComponent: CapturingAllAnnouncementsComponent {
        return componentFactory.stubbedAllAnnouncementsComponent
    }

    var stubbedEventComponent: CapturingScheduleEventComponent {
        return componentFactory.stubbedEventComponent
    }

    var stubbedUserWidgetComponent: CapturingUserWidgetComponent {
        return componentFactory.stubbedUserWidgetComponent
    }

    func bindComponent(at indexPath: IndexPath) -> Any? {
        return capturedBinder?.bindComponent(at: indexPath, using: componentFactory)
    }

    func simulateSelectingComponent(at indexPath: IndexPath) {
        delegate?.newsSceneDidSelectComponent(at: indexPath)
    }

}
