public protocol MessageDetailScene: class {

    var delegate: MessageDetailSceneDelegate? { get set }
    
    func showLoadingIndicator()
    func hideLoadingIndicator()

    func setMessageDetailTitle(_ title: String)
    func addMessageComponent(with binder: MessageComponentBinder)

}

public protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()

}
