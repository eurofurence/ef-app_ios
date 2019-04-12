@testable import Eurofurence
import EurofurenceModel
import XCTest

struct FavouriteEventNewsViewModel: NewsViewModel {

    var eventViewModel: EventComponentViewModel

    var numberOfComponents: Int {
        return 1
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }

    func titleForComponent(at index: Int) -> String {
        return "Favourite Event"
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(eventViewModel)
    }

    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {

    }

}

class WhenBindingFavouriteEvent_NewsPresenterShould: XCTestCase {

    func testShowTheFavouriteIndicator() {
        var eventViewModel = EventComponentViewModel.random
        eventViewModel.isFavourite = true
        let viewModel = FavouriteEventNewsViewModel(eventViewModel: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertEqual(context.newsScene.stubbedEventComponent.favouriteIconVisibility, .visible)
    }

}
