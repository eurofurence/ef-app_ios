import UIKit.UIViewController

public protocol KnowledgeListSceneFactory {

    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene

}
