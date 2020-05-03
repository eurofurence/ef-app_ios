import Eurofurence
import XCTest

public struct ModuleSwappingPrincipalWindowScene: PrincipalWindowScene {
    
    private let windowWireframe: WindowWireframe
    private let tutorialModule: TutorialModuleProviding
    private let preloadModule: PreloadModuleProviding
    private let principalContentModule: PrincipalContentModuleProviding
    
    public init(
        windowWireframe: WindowWireframe,
        tutorialModule: TutorialModuleProviding,
        preloadModule: PreloadModuleProviding,
        principalContentModule: PrincipalContentModuleProviding
    ) {
        self.windowWireframe = windowWireframe
        self.tutorialModule = tutorialModule
        self.preloadModule = preloadModule
        self.principalContentModule = principalContentModule
    }
    
    public func showTutorial() {
        let tutorialController = tutorialModule.makeTutorialModule(
            ShowPreloadingWhenTutorialFinishes(scene: self)
        )
        
        windowWireframe.setRoot(tutorialController)
    }
    
    public func showPreloading() {
        let preloadController = preloadModule.makePreloadModule(
            NavigateToAppropriateModuleWhenPreloadConcludes(scene: self)
        )
        
        windowWireframe.setRoot(preloadController)
    }
    
    public func showContent() {
        let contentController = principalContentModule.makePrincipalContentModule()
        windowWireframe.setRoot(contentController)
    }
    
    private struct ShowPreloadingWhenTutorialFinishes: TutorialModuleDelegate {
        
        let scene: ModuleSwappingPrincipalWindowScene
        
        func tutorialModuleDidFinishPresentingTutorial() {
            scene.showPreloading()
        }
        
    }
    
    private struct NavigateToAppropriateModuleWhenPreloadConcludes: PreloadModuleDelegate {
        
        let scene: ModuleSwappingPrincipalWindowScene
        
        func preloadModuleDidCancelPreloading() {
            scene.showTutorial()
        }
        
        func preloadModuleDidFinishPreloading() {
            scene.showContent()
        }
        
    }
    
}

public protocol PrincipalContentModuleProviding {
    
    func makePrincipalContentModule() -> UIViewController
    
}

struct StubPrincipalContentModuleProviding: PrincipalContentModuleProviding {
    
    let stubInterface = UIViewController()
    func makePrincipalContentModule() -> UIViewController {
        stubInterface
    }
    
}

class ModuleSwappingPrincipalWindowSceneTests: XCTestCase {
    
    var windowWireframe: CapturingWindowWireframe!
    var tutorialModule: StubTutorialModuleFactory!
    var preloadModule: StubPreloadModuleFactory!
    var principalContentModule: StubPrincipalContentModuleProviding!
    var windowScene: ModuleSwappingPrincipalWindowScene!
    
    override func setUp() {
        super.setUp()
        
        windowWireframe = CapturingWindowWireframe()
        tutorialModule = StubTutorialModuleFactory()
        preloadModule = StubPreloadModuleFactory()
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
