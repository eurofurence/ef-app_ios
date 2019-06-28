import EurofurenceModel
import UIKit.UIViewController

struct MessageDetailModuleFactory: MessageDetailModuleProviding {

    var messageDetailSceneFactory: MessageDetailSceneFactory
    var privateMessagesService: PrivateMessagesService

    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        let scene = messageDetailSceneFactory.makeMessageDetailScene()
        if let entity = privateMessagesService.fetchMessage(identifiedBy: message) {
            _ = MessageDetailPresenter(message: entity, scene: scene)
        }

        return scene
    }

}
