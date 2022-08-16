import ComponentBase
import EurofurenceModel
import Foundation.NSDateFormatter

public class MessagesComponentBuilder {

    private var sceneFactory: MessagesSceneFactory
    private let authenticationService: AuthenticationService
    private let privateMessagesService: PrivateMessagesService
    private var dateFormatter: DateFormatterProtocol
    private var markdownRenderer: MarkdownRenderer

    public init(authenticationService: AuthenticationService, privateMessagesService: PrivateMessagesService) {
        self.authenticationService = authenticationService
        self.privateMessagesService = privateMessagesService
        self.sceneFactory = StoryboardMessagesSceneFactory()
        self.dateFormatter = EurofurenceDateFormatter()
        self.markdownRenderer = SubtleDownMarkdownRenderer()
    }

    public func with(_ sceneFactory: MessagesSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func with(_ dateFormatter: DateFormatterProtocol) -> Self {
        self.dateFormatter = dateFormatter
        return self
    }
    
    @discardableResult
    public func with(_ markdownRenderer: MarkdownRenderer) -> Self {
        self.markdownRenderer = markdownRenderer
        return self
    }

    public func build() -> MessagesComponentFactory {
        MessagesComponentFactoryImpl(
            sceneFactory: sceneFactory,
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService,
            dateFormatter: dateFormatter,
            markdownRenderer: markdownRenderer
        )
    }

}
