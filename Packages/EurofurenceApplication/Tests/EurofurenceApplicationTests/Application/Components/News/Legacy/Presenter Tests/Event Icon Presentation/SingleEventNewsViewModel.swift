import EurofurenceApplication
import EurofurenceModel
import Foundation

struct SingleEventNewsViewModel: NewsViewModel {

    var event: EventComponentViewModel

    var numberOfComponents: Int { return 1 }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }

    func titleForComponent(at index: Int) -> String {
        return "Event"
    }

    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(event)
    }

    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) { }

}
