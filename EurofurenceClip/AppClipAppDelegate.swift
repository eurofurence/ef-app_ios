import ComponentBase
import EurofurenceClipLogic
import UIKit

@main
class AppClipAppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        prepareApplication()
        return true
    }

    func application(
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
