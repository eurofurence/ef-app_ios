public protocol MessageDetailScene: class {

    var delegate: MessageDetailSceneDelegate? { get set }
    
    func setMessageDetailTitle(_ title: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showMessage(viewModel: MessageDetailViewModel)
    func showError(viewModel: MessageDetailErrorViewModel)

}

public protocol MessageDetailViewModel {
    
    var subject: String { get }
    var contents: String { get }
    
}

public protocol MessageDetailErrorViewModel {
    
    var errorDescription: String { get }
    
    func retry()
    
}

public protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()

}
