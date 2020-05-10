@testable import Eurofurence
import EurofurenceModel
import XCTest

class ViewAllAnnouncementsViewModel: NewsViewModel {

    private let component: ViewAllAnnouncementsComponentViewModel

    init(component: ViewAllAnnouncementsComponentViewModel) {
        self.component = component
    }

    var numberOfComponents: Int {
        return 1
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }

    func titleForComponent(at index: Int) -> String {
        return "All Announcements"
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(component)
    }

    private var models = [IndexPath: NewsViewModelValue]()
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        completionHandler(.allAnnouncements)
    }

}

class WhenBindingAllAnnouncementsComponent_NewsPresenterShould: XCTestCase {

    func testBindTheCaptionOntoTheComponent() {
        let component = ViewAllAnnouncementsComponentViewModel(caption: .random)
        let viewModel = ViewAllAnnouncementsViewModel(component: component)
        let indexPath = IndexPath(row: 0, section: 0)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        XCTAssertEqual(component.caption, context.newsScene.stubbedAllAnnouncementsComponent.capturedCaption)
    }

    func testTellTheDelegateToShowAllAnnouncements() {
        let component = ViewAllAnnouncementsComponentViewModel(caption: .random)
        let viewModel = ViewAllAnnouncementsViewModel(component: component)
        let indexPath = IndexPath(row: 0, section: 0)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        context.selectComponent(at: indexPath)

        XCTAssertTrue(context.delegate.showAllAnnouncementsRequested)
    }

}
