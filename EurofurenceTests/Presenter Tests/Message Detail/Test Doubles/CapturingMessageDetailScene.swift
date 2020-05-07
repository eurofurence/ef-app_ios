import Eurofurence
import UIKit

class CapturingMessageDetailScene: UIViewController, MessageDetailScene {

    var delegate: MessageDetailSceneDelegate?
    
    private(set) var loadingIndicatorVisibility: VisibilityState = .unset
    private(set) var viewModel: MessageDetailViewModel?
    private(set) var errorViewModel: MessageDetailErrorViewModel?
    
    func showLoadingIndicator() {
        loadingIndicatorVisibility = .visible
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorVisibility = .hidden
    }
    
    func showMessage(viewModel: MessageDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func showError(viewModel: MessageDetailErrorViewModel) {
        errorViewModel = viewModel
    }

    private(set) var capturedMessageDetailTitle: String?
    func setMessageDetailTitle(_ title: String) {
        capturedMessageDetailTitle = title
    }

    private(set) var numberOfMessageComponentsAdded = 0
    private(set) var capturedMessageBinder: MessageComponentBinder?
    func addMessageComponent(with binder: MessageComponentBinder) {
        numberOfMessageComponentsAdded += 1
        capturedMessageBinder = binder
    }
    
    func simulateSceneReady() {
        delegate?.messageDetailSceneDidLoad()
    }
    
}