import Eurofurence
import XCTest

class FakeContentRouter: ContentRouter, ContentRepresentationRecipient {
    
    private var erasedRoutedContent: AnyContentRepresentation?
    func route<Content>(_ content: Content) throws
        where Content: ContentRepresentationDescribing {
        content.describe(to: self)
    }
    
    func receive<Content>(_ content: Content) where Content: ContentRepresentation {
        erasedRoutedContent = content.eraseToAnyContentRepresentation()
    }
    
    func assertRouted<Content>(
        to expected: Content,
        file: StaticString = #file,
        line: UInt = #line
    ) where Content: ContentRepresentation {
        XCTAssertEqual(
            expected.eraseToAnyContentRepresentation(),
            erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
}
