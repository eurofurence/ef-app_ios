import EurofurenceModel
import UIKit.UIViewController

struct MessagesModule: MessagesModuleProviding {

    var sceneFactory: MessagesSceneFactory
    var authenticationService: AuthenticationService
    var privateMessagesService: PrivateMessagesService
    var dateFormatter: DateFormatterProtocol

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeMessagesScene()
        _ = MessagesPresenter(scene: scene,
                              authenticationService: authenticationService,
                              privateMessagesService: privateMessagesService,
                              dateFormatter: dateFormatter,
                              delegate: delegate)

        return scene
    }

}
