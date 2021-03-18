import ComponentBase

public class CapturingAlertRouter: AlertRouter {
    
    public init() {
        
    }

    public var automaticallyPresentAlerts = false

    public private(set) var didShowAlert = false
    public private(set) var presentedAlertTitle: String?
    public private(set) var presentedAlertMessage: String?
    public private(set) var presentedActions = [AlertAction]()
    private var capturedPresentationCompletedHandler: ((AlertDismissable) -> Void)?
    public private(set) var lastAlert: CapturingAlertDismissable?
    public func show(_ alert: Alert) {
        didShowAlert = true
        presentedAlertTitle = alert.title
        presentedAlertMessage = alert.message
        presentedActions = alert.actions
        capturedPresentationCompletedHandler = alert.onCompletedPresentation

        let dismissable = CapturingAlertDismissable()
        lastAlert = dismissable

        if automaticallyPresentAlerts { completePendingPresentation() }
    }

    public func capturedAction(title: String) -> AlertAction? {
        return presentedActions.first(where: { $0.title == title })
    }

    public func completePendingPresentation() {
        capturedPresentationCompletedHandler?(lastAlert.unsafelyUnwrapped)
    }

}

public class CapturingAlertDismissable: AlertDismissable {

    public private(set) var dismissed = false
    private var capturedDismissalCompletionHandler: (() -> Void)?
    public func dismiss(_ completionHandler: (() -> Void)?) {
        dismissed = true
        capturedDismissalCompletionHandler = completionHandler
    }

    public func completeDismissal() {
        capturedDismissalCompletionHandler?()
    }

}
