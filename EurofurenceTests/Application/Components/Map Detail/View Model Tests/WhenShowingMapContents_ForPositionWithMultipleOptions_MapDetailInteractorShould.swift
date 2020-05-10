@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenShowingMapContents_ForPositionWithMultipleOptions_MapDetailViewModelFactoryShould: XCTestCase {

    func testEmitViewModelWithExpectedOptionNames() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let dealer = FakeDealer.random
        let room = Room.random
		let locationName = String.random
        let content: MapContent = .multiple([.dealer(dealer), .room(room), .location(x: .random, y: .random, name: locationName)])
        randomMap.element.stub(content: content, atX: Int(x), y: Int(y))
        
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }
        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        let expectedOptions = [dealer.preferredName, room.name, locationName]

        XCTAssertEqual(expectedOptions, visitor.capturedMapContents?.options)
    }

    func testEmitViewModelWithExpectedTitle() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let dealer = FakeDealer.random
        let room = Room.random
        let locationName = String.random
        let content: MapContent = .multiple([.dealer(dealer), .room(room), .location(x: .random, y: .random, name: locationName)])
        randomMap.element.stub(content: content, atX: Int(x), y: Int(y))
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)

        XCTAssertEqual(.selectAnOption, visitor.capturedMapContents?.optionsHeading)
    }

    func testEmitExpectedModelWhenSelectingOption() {
        let mapsService = FakeMapsService()
        let randomMap = mapsService.maps.randomElement()
        let (x, y) = (Float.random, Float.random)
        let dealer = FakeDealer.random
        let room = Room.random
        let locationName = String.random
        let contents: [MapContent] = [.dealer(dealer), .room(room), .location(x: .random, y: .random, name: locationName)]
        let content: MapContent = .multiple(contents)
        randomMap.element.stub(content: content, atX: Int(x), y: Int(y))
        let viewModelFactory = DefaultMapDetailViewModelFactory(mapsService: mapsService)
        var viewModel: MapDetailViewModel?
        viewModelFactory.makeViewModelForMap(identifier: randomMap.element.identifier) { viewModel = $0 }

        let visitor = CapturingMapContentVisitor()
        viewModel?.showContentsAtPosition(x: x, y: y, describingTo: visitor)
        visitor.capturedMapContents?.selectOption(at: 0)

        XCTAssertEqual(dealer.identifier, visitor.capturedDealer)
    }

}
