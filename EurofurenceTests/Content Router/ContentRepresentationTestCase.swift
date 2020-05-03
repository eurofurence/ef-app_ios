import Eurofurence
import XCTest

class ContentRepresentationTestCase: XCTestCase {
    
    final func assert<T, U>(
        content: T,
        isDescribedAs expected: U,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: ContentRepresentationDescribing, U: ContentRepresentation {
        let recipient = CapturingContentRepresentationRecipient()
        content.describe(to: recipient)
        
        XCTAssertEqual(
            expected.eraseToAnyContentRepresentation(),
            recipient.erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
}
