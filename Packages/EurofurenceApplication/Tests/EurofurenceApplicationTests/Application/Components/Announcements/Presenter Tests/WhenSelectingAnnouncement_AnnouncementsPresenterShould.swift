import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenSelectingAnnouncement_AnnouncementsPresenterShould: XCTestCase {
    
    var context: AnnouncementsPresenterTestBuilder.Context!
    var viewModel: FakeAnnouncementsListViewModel!
    var randomAnnouncement: (index: Int, AnnouncementItemViewModel)!
    
    override func setUp() {
        super.setUp()
        
        viewModel = FakeAnnouncementsListViewModel()
        let viewModelFactory = FakeAnnouncementsViewModelFactory(viewModel: viewModel)
        context = AnnouncementsPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidSelectAnnouncement(at: randomAnnouncement.index)
    }

    func testTellTheModuleDelegateWhichAnnouncementWasSelected() {
        let expected = viewModel.identifierForAnnouncement(at: randomAnnouncement.index)
        XCTAssertEqual(expected, context.delegate.capturedSelectedAnnouncement)
    }

    func testTellTheSceneToDeselectTheSelectedAnnouncement() {
        XCTAssertEqual(randomAnnouncement.index, context.scene.capturedAnnouncementIndexToDeselect)
    }

}
