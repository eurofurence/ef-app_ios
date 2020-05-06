public protocol MessageDetailScene: class {

    var delegate: MessageDetailSceneDelegate? { get set }
    
    func setMessageDetailTitle(_ title: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showMessage(viewModel: MessageDetailViewModel)

    // OLD
    func addMessageComponent(with binder: MessageComponentBinder)

}

public protocol MessageDetailViewModel {
    
    var subject: String { get }
    var contents: String { get }
    
}

public protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()

}
