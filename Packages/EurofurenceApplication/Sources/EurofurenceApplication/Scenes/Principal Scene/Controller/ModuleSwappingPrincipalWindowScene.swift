import PreloadComponent
import TutorialComponent

public struct ModuleSwappingPrincipalWindowScene: PrincipalWindowScene {
    
    private let windowWireframe: WindowWireframe
    private let tutorialModule: TutorialComponentFactory
    private let preloadModule: PreloadComponentFactory
    private let principalContentModule: PrincipalContentModuleProviding
    
    public init(
        windowWireframe: WindowWireframe,
        tutorialModule: TutorialComponentFactory,
        preloadModule: PreloadComponentFactory,
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
        let preloadController = preloadModule.makePreloadComponent(
            NavigateToAppropriateModuleWhenPreloadConcludes(scene: self)
        )
        
        windowWireframe.setRoot(preloadController)
    }
    
    public func showContent() {
        let contentController = principalContentModule.makePrincipalContentModule()
        windowWireframe.setRoot(contentController)
    }
    
    private struct ShowPreloadingWhenTutorialFinishes: TutorialComponentDelegate {
        
        let scene: ModuleSwappingPrincipalWindowScene
        
        func tutorialModuleDidFinishPresentingTutorial() {
            scene.showPreloading()
        }
        
    }
    
    private struct NavigateToAppropriateModuleWhenPreloadConcludes: PreloadComponentDelegate {
        
        let scene: ModuleSwappingPrincipalWindowScene
        
        func preloadModuleDidCancelPreloading() {
            scene.showTutorial()
        }
        
        func preloadModuleDidFinishPreloading() {
            scene.showContent()
        }
        
    }
    
}
