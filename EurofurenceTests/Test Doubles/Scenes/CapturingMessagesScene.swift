import Eurofurence
import EurofurenceModel
import Foundation
import UIKit.UIViewController

class StubMessagesSceneFactory: MessagesSceneFactory {

    let scene = CapturingMessagesScene()
    func makeMessagesScene() -> UIViewController & MessagesScene {
        return scene
    }

}

class CapturingMessagesScene: UIViewController, MessagesScene {

    var delegate: MessagesSceneDelegate?
    
    private(set) var refreshIndicatorVisibility: VisibilityState = .unset
    private(set) var messagesListVisibility: VisibilityState = .unset
    private(set) var noMessagesPlaceholderVisibility: VisibilityState = .unset

    private(set) var capturedTitle: String?
    func setMessagesTitle(_ title: String) {
        capturedTitle = title
    }

    func showRefreshIndicator() {
        refreshIndicatorVisibility = .visible
    }

    func hideRefreshIndicator() {
        refreshIndicatorVisibility = .hidden
    }

    private(set) var boundMessageCount: Int?
    private(set) var capturedMessageItemBinder: MessageItemBinder?
    func bindMessages(count: Int, with binder: MessageItemBinder) {
        boundMessageCount = count
        capturedMessageItemBinder = binder
    }

    func showMessagesList() {
        messagesListVisibility = .visible
    }

    func hideMessagesList() {
        messagesListVisibility = .hidden
    }

    func showNoMessagesPlaceholder() {
        noMessagesPlaceholderVisibility = .visible
    }

    func hideNoMessagesPlaceholder() {
        noMessagesPlaceholderVisibility = .hidden
    }

    func tapMessage(at index: Int) {
        delegate?.messagesSceneDidSelectMessage(at: IndexPath(indexes: [0, index]))
    }

}

class CapturingMessageItemScene: MessageItemScene {

    private(set) var capturedAuthor: String?
    func setAuthor(_ author: String) {
        capturedAuthor = author
    }

    private(set) var capturedSubject: String?
    func setSubject(_ subject: String) {
        capturedSubject = subject
    }

    private(set) var capturedContents: String?
    func setContents(_ contents: String) {
        capturedContents = contents
    }

    private(set) var capturedReceivedDateTime: String?
    func setReceivedDateTime(_ dateTime: String) {
        capturedReceivedDateTime = dateTime
    }

    private(set) var unreadIndicatorVisibility: VisibilityState = .unset
    func showUnreadIndicator() {
        unreadIndicatorVisibility = .visible
    }

    func hideUnreadIndicator() {
        unreadIndicatorVisibility = .hidden
    }

}
