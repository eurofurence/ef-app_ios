@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenKnowledgeGroupsListViewModelIsPrepared: XCTestCase {

    var context: KnowledgeGroupsPresenterTestBuilder.Context!
    var viewModel: StubKnowledgeGroupsListViewModel!

    override func setUp() {
        super.setUp()

        context = KnowledgeGroupsPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        viewModel = .random
        context.simulateLoadingViewModel(viewModel)
    }

    func testTheSceneIsToldToHideTheLoadingIndicator() {
        XCTAssertTrue(context.scene.didHideLoadingIndicator)
    }

    func testTheSceneIsToldToDisplayKnowledgeGroups() {
        let expected = viewModel.knowledgeGroups.count
        XCTAssertEqual(expected, context.scene.capturedEntriesPerGroup)
    }

    func testBindingKnowledgeGroupHeadingSetsTitleOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.title
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)

        XCTAssertEqual(expected, scene.capturedTitle)
    }

    func testBindingKnowledgeGroupHeadingSetsFontAwesomeCharacterOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.fontAwesomeCharacter
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)

        XCTAssertEqual(expected, scene.capturedFontAwesomeCharacter)
    }

    func testBindingKnowledgeGroupHeadingSetsDescriptionOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.groupDescription
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)

        XCTAssertEqual(expected, scene.capturedGroupDescription)
    }

    func testSelectingKnowledgeGroupTellsSceneToDeselectSelectedItem() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        context.scene.simulateSelectingKnowledgeGroup(at: randomGroup.index)
        let expected = IndexPath(item: randomGroup.index, section: 0)

        XCTAssertEqual(expected, context.scene.deselectedIndexPath)
    }

    func testSelectingKnowledgeGroupTellsDelegateTheIndexedGroupIdentifierWasChosen() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        context.scene.simulateSelectingKnowledgeGroup(at: randomGroup.index)
        let expected = viewModel.stubbedGroupIdentifier(at: randomGroup.index)

        XCTAssertEqual(expected, context.delegate.capturedKnowledgeGroupToPresent)
    }

}
