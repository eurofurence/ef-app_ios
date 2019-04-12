protocol MessageDetailScene: class {

    var delegate: MessageDetailSceneDelegate? { get set }

    func setMessageDetailTitle(_ title: String)
    func addMessageComponent(with binder: MessageComponentBinder)

}

protocol MessageDetailSceneDelegate {

    func messageDetailSceneDidLoad()

}
