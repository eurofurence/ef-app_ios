import UIKit.UIViewController

protocol KnowledgeDetailSceneFactory {

    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene

}
