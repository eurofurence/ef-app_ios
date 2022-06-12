import ContentController
import XCTest

class ComponentBasedBootstrappingSceneTests: XCTestCase {
    
    var windowWireframe: CapturingWindowWireframe!
    var tutorialModule: StubTutorialComponentFactory!
    var preloadModule: StubPreloadComponentFactory!
    var principalContentModule: StubPrincipalContentModuleProviding!
    var windowScene: ComponentBasedBootstrappingScene!
    
    override func setUp() {
        super.setUp()
        
        windowWireframe = CapturingWindowWireframe()
        tutorialModule = StubTutorialComponentFactory()
        preloadModule = StubPreloadComponentFactory()
        principalContentModule = StubPrincipalContentModuleProviding()
        windowScene = ComponentBasedBootstrappingScene(
            windowWireframe: windowWireframe,
            tutorialModule: tutorialModule,
            preloadModule: preloadModule,
            principalContentModule: principalContentModule
        )
    }
    
    func testShowingTutorial() {
        XCTAssertNil(windowWireframe.capturedRootInterface)
        
        windowScene.showTutorial()
        
        XCTAssertEqual(tutorialModule.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testShowingPreload() {
        XCTAssertNil(windowWireframe.capturedRootInterface)
        
        windowScene.showPreloading()
        
        XCTAssertEqual(preloadModule.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testShowingContent() {
        XCTAssertNil(windowWireframe.capturedRootInterface)
        
        windowScene.showContent()
        
        XCTAssertEqual(principalContentModule.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testMovingFromTutorialToPreload() {
        windowScene.showTutorial()
        tutorialModule.simulateTutorialFinished()
        
        XCTAssertEqual(preloadModule.stubInterface, windowWireframe.capturedRootInterface)
    }
    
    func testMovingFromPreloadBackToTutorial() {
        windowScene.showTutorial()
        tutorialModule.simulateTutorialFinished()
        preloadModule.simulatePreloadCancelled()
        
        XCTAssertEqual(tutorialModule.stubInterface, windowWireframe.capturedRootInterface)
    }

}
