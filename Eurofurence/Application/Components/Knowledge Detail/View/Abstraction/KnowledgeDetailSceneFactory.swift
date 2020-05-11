import UIKit.UIViewController

public protocol KnowledgeDetailSceneFactory {

    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene

}
