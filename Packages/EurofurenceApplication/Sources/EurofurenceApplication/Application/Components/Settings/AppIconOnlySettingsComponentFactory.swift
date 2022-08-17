import SwiftUI
import UIKit

struct AppIconOnlySettingsComponentFactory: SettingsComponentFactory {
    
    let repository: AppIconRepository
    
    func makeSettingsModule() -> UIViewController {
        let viewModel = RepositoryBackedAppIconsViewModel(
            repository: repository,
            applicationIconState: UIKitApplicationIconState()
        )
        
        let view = AppIconPickerView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.title = NSLocalizedString(
            "SelectAppIconNavigationTitle",
            bundle: .module,
            comment: "Title for the view shown to prompt the user to select an alternative app icon"
        )
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
}
