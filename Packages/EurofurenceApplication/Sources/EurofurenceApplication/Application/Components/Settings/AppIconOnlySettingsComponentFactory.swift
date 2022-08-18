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
        let viewController = AppIconPickerViewController(rootView: view)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
    
    private typealias RepositoryBackedViewModel = RepositoryBackedAppIconsViewModel<UIKitApplicationIconState>
    private typealias SettingsAppIconPickerView = AppIconPickerView<RepositoryBackedViewModel>
    
    private class AppIconPickerViewController: UIHostingController<SettingsAppIconPickerView> {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationItem.title = NSLocalizedString(
                "SelectAppIconNavigationTitle",
                bundle: .module,
                comment: "Title for the view shown to prompt the user to select an alternative app icon"
            )
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(dismissAppIconPicker(_:))
            )
        }
        
        @objc private func dismissAppIconPicker(_ sender: Any) {
            presentingViewController?.dismiss(animated: true)
        }
        
    }
    
}
