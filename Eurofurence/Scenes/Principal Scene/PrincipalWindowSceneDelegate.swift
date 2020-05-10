import UIKit

@available(iOS 13.0, *)
class PrincipalWindowSceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            Application.instance.configurePrincipalScene(window: window)
            window.makeKeyAndVisible()
        }
    }
    
}
