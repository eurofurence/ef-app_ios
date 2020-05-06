import EurofurenceModel
import UIKit.UIViewController

struct MessageDetailModuleFactory: MessageDetailModuleProviding {

    var messageDetailSceneFactory: MessageDetailSceneFactory
    var privateMessagesService: PrivateMessagesService

    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        let scene = messageDetailSceneFactory.makeMessageDetailScene()
        
        privateMessagesService.fetchMessage(identifiedBy: message) { (result) in
            if case .success(let entity) = result {
                _ = MessageDetailPresenter(message: entity, scene: scene)
            }
        }

        return scene
    }

}
