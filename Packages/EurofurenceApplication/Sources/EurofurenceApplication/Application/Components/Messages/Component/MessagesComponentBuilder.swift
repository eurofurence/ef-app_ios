import ComponentBase
import EurofurenceModel
import Foundation.NSDateFormatter

public class MessagesComponentBuilder {

    private var sceneFactory: MessagesSceneFactory
    private let authenticationService: AuthenticationService
    private let privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol

    public init(authenticationService: AuthenticationService, privateMessagesService: PrivateMessagesService) {
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService
        sceneFactory = StoryboardMessagesSceneFactory()
        dateFormatter = EurofurenceDateFormatter()
    }

    public func with(_ sceneFactory: MessagesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func with(_ dateFormatter: DateFormatterProtocol) -> Self {
        self.dateFormatter = dateFormatter
        return self
    }

    public func build() -> MessagesComponentFactory {
        MessagesComponentFactoryImpl(
            sceneFactory: sceneFactory,
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService,
            dateFormatter: dateFormatter
        )
    }

}
