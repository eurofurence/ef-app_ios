import EurofurenceModel
import KnowledgeGroupsComponent
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

    func testTheKnowledgeGroupsAreBound() {
        let expected = viewModel.knowledgeGroups.count
        
        XCTAssertEqual(expected, context.scene.capturedEntriesPerGroup)
        XCTAssertTrue(context.scene.didHideLoadingIndicator)
    }

    func testBindingKnowledgeGroup() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)

        XCTAssertEqual(randomGroup.element.title, scene.capturedTitle)
        XCTAssertEqual(randomGroup.element.fontAwesomeCharacter, scene.capturedFontAwesomeCharacter)
        XCTAssertEqual(randomGroup.element.groupDescription, scene.capturedGroupDescription)
    }

    func testSelectingKnowledgeGroup() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        context.scene.simulateSelectingKnowledgeGroup(at: randomGroup.index)
        let expectedIdentifier = viewModel.stubbedGroupIdentifier(at: randomGroup.index)

        XCTAssertEqual(expectedIdentifier, context.delegate.capturedKnowledgeGroupToPresent)
    }

}
