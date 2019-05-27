import EurofurenceModel
import UIKit.UIViewController

class MessageDetailModuleBuilder {

    private var messageDetailSceneFactory: MessageDetailSceneFactory
    private let privateMessagesService: PrivateMessagesService

    init(privateMessagesService: PrivateMessagesService) {
        self.privateMessagesService = privateMessagesService
        messageDetailSceneFactory = StoryboardMessageDetailSceneFactory()
    }

    func with(_ messageDetailSceneFactory: MessageDetailSceneFactory) -> MessageDetailModuleBuilder {
        self.messageDetailSceneFactory = messageDetailSceneFactory
        return self
    }

    func build() -> MessageDetailModuleProviding {
        return MessageDetailModuleFactory(messageDetailSceneFactory: messageDetailSceneFactory,
                                          privateMessagesService: privateMessagesService)
    }

}
