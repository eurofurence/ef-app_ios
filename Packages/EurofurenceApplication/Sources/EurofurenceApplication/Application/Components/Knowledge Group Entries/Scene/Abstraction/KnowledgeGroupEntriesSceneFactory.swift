import UIKit

public protocol KnowledgeGroupEntriesSceneFactory {

    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene

}
