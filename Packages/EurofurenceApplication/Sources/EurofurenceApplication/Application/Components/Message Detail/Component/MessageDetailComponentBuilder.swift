import ComponentBase
import EurofurenceModel

public class MessageDetailComponentBuilder {
    
    private let messagesService: PrivateMessagesService
    private var markdownRenderer: MarkdownRenderer
    private var sceneFactory: MessageDetailSceneFactory
    
    public init(messagesService: PrivateMessagesService) {
        self.messagesService = messagesService
        self.sceneFactory = StoryboardMessageDetailSceneFactory()
        self.markdownRenderer = DefaultDownMarkdownRenderer()
    }
    
    @discardableResult
    public func with(_ sceneFactory: MessageDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    @discardableResult
    public func with(_ markdownRenderer: MarkdownRenderer) -> Self {
        self.markdownRenderer = markdownRenderer
        return self
    }
    
    public func build() -> MessageDetailComponentFactory {
        MessageDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            messagesService: messagesService,
            markdownRenderer: markdownRenderer
        )
    }
    
}
