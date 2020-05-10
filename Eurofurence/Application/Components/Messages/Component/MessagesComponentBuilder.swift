import EurofurenceModel
import Foundation.NSDateFormatter

class MessagesComponentBuilder {

    private var sceneFactory: MessagesSceneFactory
    private let authenticationService: AuthenticationService
    private let privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol

    init(authenticationService: AuthenticationService, privateMessagesService: PrivateMessagesService) {
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService
        sceneFactory = StoryboardMessagesSceneFactory()
        dateFormatter = EurofurenceDateFormatter()
    }

    func with(_ sceneFactory: MessagesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ dateFormatter: DateFormatterProtocol) -> Self {
        self.dateFormatter = dateFormatter
        return self
    }

    func build() -> MessagesComponentFactory {
        MessagesComponentFactoryImpl(
            sceneFactory: sceneFactory,
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService,
            dateFormatter: dateFormatter
        )
    }

}
