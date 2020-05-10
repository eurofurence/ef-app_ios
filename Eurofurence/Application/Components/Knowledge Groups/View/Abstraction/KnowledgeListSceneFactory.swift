import UIKit.UIViewController

protocol KnowledgeListSceneFactory {

    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene

}
