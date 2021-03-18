import EurofurenceApplication

class CapturingContentBootstrappingScene: ContentBootstrappingScene {
    
    enum VisibleScene: Equatable {
        case none
        case tutorial
        case preloading
        case content
    }
    
    private(set) var visibleScene: VisibleScene = .none
    
    func showTutorial() {
        visibleScene = .tutorial
    }
    
    func showPreloading() {
        visibleScene = .preloading
    }
    
    func showContent() {
        visibleScene = .content
    }
    
}
