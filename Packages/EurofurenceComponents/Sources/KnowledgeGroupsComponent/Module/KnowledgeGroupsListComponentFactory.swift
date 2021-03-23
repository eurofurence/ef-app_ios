import UIKit.UIViewController

public protocol KnowledgeGroupsListComponentFactory {

    func makeKnowledgeListComponent(
        _ delegate: KnowledgeGroupsListComponentDelegate
    ) -> UIViewController

}
