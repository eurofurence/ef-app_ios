import Eurofurence
import XCTest

class FakeContentRouter: ContentRouter {
    
    private(set) var erasedRoutedContent: AnyContentRepresentation?
    func route(_ content: AnyContentRepresentation) throws {
        erasedRoutedContent = content
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
    
    func unwrapRoutedContent<Target>(
        into targetType: Target.Type = Target.self,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Target where Target: ContentRepresentation {
        let unwrapper: Unwrapper<Target> = Unwrapper()
        erasedRoutedContent?.describe(to: unwrapper)
        
        return try XCTUnwrap(unwrapper.unwrapped, file: file, line: line)
    }
    
    private class Unwrapper<Target>: ContentRepresentationRecipient where Target: ContentRepresentation {
        
        var unwrapped: Target?
        
        func receive<Content>(_ content: Content) where Content: ContentRepresentation {
            unwrapped = content as? Target
        }
        
    }
    
}
