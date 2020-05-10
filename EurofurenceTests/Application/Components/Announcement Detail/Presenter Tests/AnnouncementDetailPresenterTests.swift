import Eurofurence
import EurofurenceModel
import XCTest

class AnnouncementDetailPresenterTests: XCTestCase {
    
    var context: AnnouncementDetailPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = AnnouncementDetailPresenterTestBuilder().build()
    }
    
    func testTheSceneIsReturnedFromTheModuleFactory() {
        XCTAssertEqual(context.announcementDetailScene, context.sceneFactory.stubbedScene)
    }

    func testTheSceneIsToldToShowTheAnnouncementTitle() {
        XCTAssertEqual(.announcement, context.scene.capturedTitle)
    }

    func testAnnouncementFieldsBoundAfterSceneDidLoad() {
        XCTAssertNil(context.scene.capturedAnnouncementHeading)
        XCTAssertNil(context.scene.capturedAnnouncementContents)
        XCTAssertNil(context.scene.capturedAnnouncementImagePNGData)
        
        context.simulateAnnouncementDetailSceneDidLoad()
        
        XCTAssertEqual(context.announcementViewModel.heading, context.scene.capturedAnnouncementHeading)
        XCTAssertEqual(context.announcementViewModel.contents, context.scene.capturedAnnouncementContents)
        XCTAssertEqual(context.announcementViewModel.imagePNGData, context.scene.capturedAnnouncementImagePNGData)
    }

}
