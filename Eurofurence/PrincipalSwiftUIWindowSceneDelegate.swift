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
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let rootView = HandheldExperience()
            .environmentModel(AppModel.shared.model)
        
        let rootViewController = UIHostingController(rootView: rootView)
        window.rootViewController = rootViewController
        
        window.makeKeyAndVisible()
    }
    
}
