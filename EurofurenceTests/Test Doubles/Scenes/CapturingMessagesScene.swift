@testable import Eurofurence
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

    private(set) var capturedTitle: String?
    func setMessagesTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var wasToldToShowRefreshIndicator = false
    func showRefreshIndicator() {
        wasToldToShowRefreshIndicator = true
    }

    private(set) var wasToldToHideRefreshIndicator = false
    func hideRefreshIndicator() {
        wasToldToHideRefreshIndicator = true
    }

    private(set) var boundMessageCount: Int?
    private(set) var capturedMessageItemBinder: MessageItemBinder?
    func bindMessages(count: Int, with binder: MessageItemBinder) {
        boundMessageCount = count
        capturedMessageItemBinder = binder
    }

    private(set) var didShowMessages = false
    func showMessagesList() {
        didShowMessages = true
    }

    private(set) var didHideMessages = false
    func hideMessagesList() {
        didHideMessages = true
    }

    var didShowNoMessagesPlaceholder = false
    func showNoMessagesPlaceholder() {
        didShowNoMessagesPlaceholder = true
    }

    private(set) var didHideNoMessagesPlaceholder = false
    func hideNoMessagesPlaceholder() {
        didHideNoMessagesPlaceholder = true
    }

    func tapMessage(at index: Int) {
        delegate?.messagesSceneDidSelectMessage(at: IndexPath(indexes: [0, index]))
    }

    func reset() {
        wasToldToShowRefreshIndicator = false
        wasToldToHideRefreshIndicator = false
        capturedMessageItemBinder = nil
        didShowMessages = false
        didHideMessages = false
        didShowNoMessagesPlaceholder = false
        didHideNoMessagesPlaceholder = false
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

class CapturingMessagesSceneDelegate: MessagesSceneDelegate {
    func messagesSceneDidTapLogoutButton() {

    }

    private(set) var toldMessagesSceneWillAppear = false
    func messagesSceneWillAppear() {
        toldMessagesSceneWillAppear = true
    }

    private(set) var capturedSelectedMessageIndexPath: IndexPath?
    func messagesSceneDidSelectMessage(at indexPath: IndexPath) {
        capturedSelectedMessageIndexPath = indexPath
    }

    private(set) var didPerformRefreshAction = false
    func messagesSceneDidPerformRefreshAction() {
        didPerformRefreshAction = true
    }

}
