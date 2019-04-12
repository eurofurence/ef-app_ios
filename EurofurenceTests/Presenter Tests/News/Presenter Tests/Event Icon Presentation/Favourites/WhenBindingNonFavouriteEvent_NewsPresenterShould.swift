@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_NewsPresenterShould: XCTestCase {

    func testTellTheComponentToHideTheFavouriteIndicator() {
        var eventViewModel = EventComponentViewModel.random
        eventViewModel.isFavourite = false
        let viewModel = FavouriteEventNewsViewModel(eventViewModel: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertEqual(context.newsScene.stubbedEventComponent.favouriteIconVisibility, .hidden)
    }

}
