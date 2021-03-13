import EurofurenceModel
import Foundation

public protocol KnowledgeEntryDetailViewModel {

    var title: String { get }
    var contents: NSAttributedString { get }
    var links: [LinkViewModel] { get }
    var images: [KnowledgeEntryImageViewModel] { get }

    func link(at index: Int) -> Link
    func shareKnowledgeEntry(_ sender: AnyObject)

}

public struct KnowledgeEntryImageViewModel: Equatable {

    public var imagePNGData: Data
    
    public init(imagePNGData: Data) {
        self.imagePNGData = imagePNGData
    }

}
