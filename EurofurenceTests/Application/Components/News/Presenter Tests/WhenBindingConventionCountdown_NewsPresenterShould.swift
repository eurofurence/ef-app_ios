import Eurofurence
import EurofurenceModel
import XCTest

struct CountdownViewModel: NewsViewModel {

    var countdownViewModel: ConventionCountdownComponentViewModel

    var numberOfComponents: Int {
        return 1
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }

    func titleForComponent(at index: Int) -> String {
        return "Countdown"
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(countdownViewModel)
    }

    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {

    }

}

class WhenBindingConventionCountdown_NewsPresenterShould: XCTestCase {

    func testSetTheTimeRemainingOntoTheCountdownWidgetScene() {
        let countdownComponentViewModel = ConventionCountdownComponentViewModel.random
        let viewModel = CountdownViewModel(countdownViewModel: countdownComponentViewModel)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(countdownComponentViewModel.timeUntilConvention,
                       context.newsScene.stubbedCountdownComponent.capturedTimeUntilConvention)
    }

}
