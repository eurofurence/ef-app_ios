import EurofurenceClipLogic
import UIKit

class AppClipSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        AppClip.shared.configurePrincipalAppClipScene(window: window)
        
        window.makeKeyAndVisible()
    }

}
