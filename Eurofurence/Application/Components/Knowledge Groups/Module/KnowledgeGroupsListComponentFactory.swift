import UIKit.UIViewController

protocol KnowledgeGroupsListComponentFactory {

    func makeKnowledgeListComponent(
        _ delegate: KnowledgeGroupsListComponentDelegate
    ) -> UIViewController

}
