import UIKit

@available(iOS 13.0, *)
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
        
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        Application.resume(activity: userActivity)
    }
    
}
