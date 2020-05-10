import XCTest

class WhenSelectingMap_MapsPresenterShould: XCTestCase {

    func testTellTheDelegateToShowDetailsForMapWithItsIdentifier() {
        let viewModel = FakeMapsViewModel()
        let viewModelFactory = FakeMapsViewModelFactory(viewModel: viewModel)
        let context = MapsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let mapViewModel = viewModel.maps.randomElement()
        context.simulateSceneDidSelectMap(at: mapViewModel.index)

        XCTAssertEqual(viewModel.identifierForMap(at: mapViewModel.index), context.delegate.capturedMapIdentifierToPresent)
    }

}
