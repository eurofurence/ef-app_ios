import EurofurenceApplication
import UIKit

class PrincipalWindowSceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        Application.instance.configurePrincipalScene(window: window)
        
        if let userActivity = connectionOptions.userActivities.first {
            Application.resume(activity: userActivity)
        }
        
        let URLContexts = connectionOptions.urlContexts
        if URLContexts.isEmpty == false {
            Application.open(URLContexts: URLContexts)
        }
        
#if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
#endif
        
        window.installDebugModule()
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        Application.open(URLContexts: URLContexts)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        Application.resume(activity: userActivity)
    }
    
}
