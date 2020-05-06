import EurofurenceModel

public class MessageDetail2ModuleBuilder {
    
    private var sceneFactory: MessageDetailSceneFactory
    
    public init() {
        sceneFactory = StoryboardMessageDetailSceneFactory()
    }
    
    @discardableResult
    public func with(_ sceneFactory: MessageDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    @discardableResult
    public func with(_ messagesService: PrivateMessagesService) -> Self {
        return self
    }
    
    public func build() -> MessageDetailModuleProviding {
        MessageDetail2ModuleProviding(sceneFactory: sceneFactory)
    }
    
}
