import EurofurenceApplication
import UIKit

class FakeCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
    
    let scene = FakeCompositionalNewsScene()
    func makeCompositionalNewsScene() -> UIViewController & CompositionalNewsScene {
        scene
    }
    
}

class FakeCompositionalNewsScene: UIViewController, CompositionalNewsScene {
    
    enum LoadingIndicatorState: Equatable {
        case unknown
        case visible
        case hidden
    }
    
    private(set) var installedDataSources = [TableViewMediator]()
    private(set) var loadingIndicatorState: LoadingIndicatorState = .unknown
    private var delegate: CompositionalNewsSceneDelegate?
    
    func setDelegate(_ delegate: CompositionalNewsSceneDelegate) {
        self.delegate = delegate
    }
    
    func install(dataSource: TableViewMediator) {
        installedDataSources.append(dataSource)
    }
    
    func showLoadingIndicator() {
        loadingIndicatorState = .visible
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorState = .hidden
    }
    
    func simulateSceneReady() {
        delegate?.sceneReady()
    }
    
    func simulateRefreshRequested() {
        delegate?.reloadRequested()
    }
    
    func simulateSettingsTapped(sender: Any) {
        delegate?.settingsTapped(sender: sender)
    }
    
}
