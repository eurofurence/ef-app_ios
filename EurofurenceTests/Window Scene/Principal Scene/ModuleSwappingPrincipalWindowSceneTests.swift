import Eurofurence
import XCTest

class ModuleSwappingPrincipalWindowSceneTests: XCTestCase {
    
    var windowWireframe: CapturingWindowWireframe!
    var tutorialModule: StubTutorialModuleFactory!
    var preloadModule: StubPreloadComponentFactoryImplFactory!
    var principalContentModule: StubPrincipalContentModuleProviding!
    var windowScene: ModuleSwappingPrincipalWindowScene!
    
    override func setUp() {
        super.setUp()
        
        windowWireframe = CapturingWindowWireframe()
        tutorialModule = StubTutorialModuleFactory()
        preloadModule = StubPreloadComponentFactoryImplFactory()
        principalContentModule = StubPrincipalContentModuleProviding()
        windowScene = ModuleSwappingPrincipalWindowScene(
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
    
    func testMovingFromPreloadToContent() {
        windowScene.showTutorial()
        tutorialModule.simulateTutorialFinished()
        preloadModule.simulatePreloadFinished()
        
        XCTAssertEqual(principalContentModule.stubInterface, windowWireframe.capturedRootInterface)
    }

}
