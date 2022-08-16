import ComponentBase
import EurofurenceModel
import UIKit.UIViewController

struct MessagesComponentFactoryImpl: MessagesComponentFactory {

    var sceneFactory: MessagesSceneFactory
    var authenticationService: AuthenticationService
    var privateMessagesService: PrivateMessagesService
    var dateFormatter: DateFormatterProtocol
    var markdownRenderer: MarkdownRenderer

    func makeMessagesModule(_ delegate: MessagesComponentDelegate) -> UIViewController {
        let scene = sceneFactory.makeMessagesScene()
        _ = MessagesPresenter(
            scene: scene,
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService,
            dateFormatter: dateFormatter,
            markdownRenderer: markdownRenderer,
            delegate: delegate
        )

        return scene
    }

}
