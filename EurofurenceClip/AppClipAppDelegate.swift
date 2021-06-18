import ComponentBase
import EurofurenceClipLogic
import UIKit

@main
public class AppClipAppDelegate: UIResponder, UIApplicationDelegate {

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        prepareApplication()
        return true
    }

    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Private
    
    private func prepareApplication() {
        Theme.global.apply()
        
        let dependencies = AppClip.Dependencies(
            eventIntentDonor: DonateFromAppEventIntentDonor(),
            dealerIntentDonor: DonateFromAppDealerIntentDonor()
        )
        
        AppClip.bootstrap(dependencies)
    }

}
