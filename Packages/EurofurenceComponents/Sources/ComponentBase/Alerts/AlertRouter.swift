import Foundation

public protocol AlertRouter {

    func show(_ alert: Alert)

}

public protocol AlertDismissable {

    func dismiss(_ completionHandler: (() -> Void)?)

}

extension AlertDismissable {

    public func dismiss() {
        dismiss(nil)
    }

}

public struct Alert {

    public var title: String
    public var message: String
    public var actions: [AlertAction]
    public var onCompletedPresentation: ((AlertDismissable) -> Void)?

    public init(title: String, message: String, actions: [AlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }

}

public struct AlertAction {

    public var title: String
    private var action: (() -> Void)?

    public init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    public func invoke() {
        action?()
    }

}
