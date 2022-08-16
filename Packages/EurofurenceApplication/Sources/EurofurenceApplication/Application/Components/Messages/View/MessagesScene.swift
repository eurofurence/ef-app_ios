import Foundation
import UIKit.UIViewController

public protocol MessagesSceneDelegate {

    func messagesSceneReady()
    func messagesSceneFinalizing()
    func messagesSceneDidSelectMessage(at indexPath: IndexPath)
    func messagesSceneDidPerformRefreshAction()
    func messagesSceneDidTapLogoutButton()

}

public protocol MessagesSceneFactory {

    func makeMessagesScene() -> UIViewController & MessagesScene

}

public protocol MessagesScene: AnyObject {

    var delegate: MessagesSceneDelegate? { get set }

    func setMessagesTitle(_ title: String)

    func showRefreshIndicator()
    func hideRefreshIndicator()

    func bindMessages(count: Int, with binder: MessageItemBinder)

    func showMessagesList()
    func hideMessagesList()

    func showNoMessagesPlaceholder()
    func hideNoMessagesPlaceholder()

}

public protocol MessageItemBinder {

    func bind(_ scene: MessageItemScene, toMessageAt indexPath: IndexPath)

}

public protocol MessageItemScene {

    func setAuthor(_ author: String)
    func setSubject(_ subject: String)
    func setContents(_ contents: NSAttributedString)
    func setReceivedDateTime(_ dateTime: String)
    func showUnreadIndicator()
    func hideUnreadIndicator()

}
