import EurofurenceClipLogic
import UIKit

class AppClipSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var principalWindowScene: WindowScene?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        principalWindowScene = AppClip.shared.configurePrincipalAppClipScene(window: window)
        
        if let userActivity = connectionOptions.userActivities.first {
            principalWindowScene?.resume(userActivity)
        }
        
        let URLContexts = connectionOptions.urlContexts
        if URLContexts.isEmpty == false {
            principalWindowScene?.open(URLContexts: URLContexts)
        }
        
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        principalWindowScene?.open(URLContexts: URLContexts)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        principalWindowScene?.resume(userActivity)
    }

}
