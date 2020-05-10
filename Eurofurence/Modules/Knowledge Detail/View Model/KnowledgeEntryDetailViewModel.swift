import EurofurenceModel
import Foundation

protocol KnowledgeEntryDetailViewModel {

    var title: String { get }
    var contents: NSAttributedString { get }
    var links: [LinkViewModel] { get }
    var images: [KnowledgeEntryImageViewModel] { get }

    func link(at index: Int) -> Link
    func shareKnowledgeEntry(_ sender: AnyObject)

}

struct KnowledgeEntryImageViewModel: Equatable {

    var imagePNGData: Data

}
