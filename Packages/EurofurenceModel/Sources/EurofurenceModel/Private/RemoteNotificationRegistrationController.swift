import Foundation

class RemoteNotificationRegistrationController {

    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var deviceToken: Data?
    private var authenticationToken: String?
    
    private struct RemoteNotificationTokenChanged: EventConsumer {
        
        private unowned let controller: RemoteNotificationRegistrationController
        
        init(controller: RemoteNotificationRegistrationController) {
            self.controller = controller
        }
        
        func consume(event: DomainEvent.RemoteNotificationTokenAvailable) {
            controller.remoteNotificationRegistrationSucceeded(event)
        }
        
    }
    
    private struct ReRegisterNotificationTokenWhenLoggedIn: EventConsumer {
        
        private unowned let controller: RemoteNotificationRegistrationController
        
        init(controller: RemoteNotificationRegistrationController) {
            self.controller = controller
        }
        
        func consume(event: DomainEvent.LoggedIn) {
            controller.userDidLogin(event)
        }
        
    }

    init(
        eventBus: EventBus,
        remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    ) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration

        eventBus.subscribe(consumer: RemoteNotificationTokenChanged(controller: self))
        eventBus.subscribe(consumer: ReRegisterNotificationTokenWhenLoggedIn(controller: self))
    }

    private func reregisterNotificationToken() {
        remoteNotificationsTokenRegistration?.registerRemoteNotificationsDeviceToken(
            deviceToken,
            userAuthenticationToken: authenticationToken,
            completionHandler: { (_) in
                
        })
    }

    private func remoteNotificationRegistrationSucceeded(_ event: DomainEvent.RemoteNotificationTokenAvailable) {
        deviceToken = event.deviceToken
        reregisterNotificationToken()
    }

    private func userDidLogin(_ event: DomainEvent.LoggedIn) {
        authenticationToken = event.authenticationToken
        reregisterNotificationToken()
    }

}
