import EurofurenceModel

public class MessageDetail2ModuleBuilder {
    
    private let messagesService: PrivateMessagesService
    private var sceneFactory: MessageDetailSceneFactory
    
    public init(messagesService: PrivateMessagesService) {
        self.messagesService = messagesService
        sceneFactory = StoryboardMessageDetailSceneFactory()
    }
    
    @discardableResult
    public func with(_ sceneFactory: MessageDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    public func build() -> MessageDetailModuleProviding {
        MessageDetail2ModuleProviding(sceneFactory: sceneFactory, messagesService: messagesService)
    }
    
}
