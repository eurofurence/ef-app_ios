@testable import Eurofurence
import EurofurenceModel

class CapturingAlertRouter: AlertRouter {

    var automaticallyPresentAlerts = false

    private(set) var didShowAlert = false
    private(set) var presentedAlertTitle: String?
    private(set) var presentedAlertMessage: String?
    private(set) var presentedActions = [AlertAction]()
    private var capturedPresentationCompletedHandler: ((AlertDismissable) -> Void)?
    private(set) var lastAlert: CapturingAlertDismissable?
    func show(_ alert: Alert) {
        didShowAlert = true
        presentedAlertTitle = alert.title
        presentedAlertMessage = alert.message
        presentedActions = alert.actions
        capturedPresentationCompletedHandler = alert.onCompletedPresentation

        let dismissable = CapturingAlertDismissable()
        lastAlert = dismissable

        if automaticallyPresentAlerts { completePendingPresentation() }
    }

    func capturedAction(title: String) -> AlertAction? {
        return presentedActions.first(where: { $0.title == title })
    }

    func completePendingPresentation() {
        capturedPresentationCompletedHandler?(unwrap(lastAlert))
    }

}

class CapturingAlertDismissable: AlertDismissable {

    private(set) var dismissed = false
    private var capturedDismissalCompletionHandler: (() -> Void)?
    func dismiss(_ completionHandler: (() -> Void)?) {
        dismissed = true
        capturedDismissalCompletionHandler = completionHandler
    }

    func completeDismissal() {
        capturedDismissalCompletionHandler?()
    }

}
