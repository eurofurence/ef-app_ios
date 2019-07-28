import EurofurenceModel
import Foundation.NSDateFormatter

class MessagesModuleBuilder {

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

    func with(_ sceneFactory: MessagesSceneFactory) -> MessagesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ dateFormatter: DateFormatterProtocol) -> MessagesModuleBuilder {
        self.dateFormatter = dateFormatter
        return self
    }

    func build() -> MessagesModuleProviding {
        return MessagesModule(sceneFactory: sceneFactory,
                              authenticationService: authenticationService,
                              privateMessagesService: privateMessagesService,
                              dateFormatter: dateFormatter)
    }

}
