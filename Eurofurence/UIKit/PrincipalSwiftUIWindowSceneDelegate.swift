import EurofurenceKit
import SwiftUI
import UIKit

class PrincipalSwiftUIWindowSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = AutoPatchSplitViewControllerWindow(windowScene: windowScene)
        self.window = window
        
        let model = AppModel.shared.model
        
        Task(priority: .userInitiated) {
            await model.prepareForPresentation()
        }
        
        let rootView = TransientOverlayContainer {
            HandheldExperience()
                .environmentModel(model)
        }
        
        let rootViewController = UIHostingController(rootView: rootView)
        window.rootViewController = rootViewController
        
        window.makeKeyAndVisible()
    }
    
}
