import EurofurenceModel
import Foundation.NSDateFormatter

class MessagesModuleBuilder {

    private var sceneFactory: MessagesSceneFactory
    private var authenticationService: AuthenticationService
    private var privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol

    init() {
        sceneFactory = StoryboardMessagesSceneFactory()
        authenticationService = ApplicationStack.instance.services.authentication
        privateMessagesService = ApplicationStack.instance.services.privateMessages
        dateFormatter = DateFormatter()
    }

    func with(_ sceneFactory: MessagesSceneFactory) -> MessagesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func with(_ authenticationService: AuthenticationService) -> MessagesModuleBuilder {
        self.authenticationService = authenticationService
        return self
    }

    func with(_ privateMessagesService: PrivateMessagesService) ->
        MessagesModuleBuilder {
        self.privateMessagesService = privateMessagesService
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
