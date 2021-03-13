import EurofurenceModel
import XCTest

class WhenDescribingKnowledgeGroupsLink: XCTestCase {

    func testTheKnowledgeGroupsContentIsProvided() throws {
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/App/Web/KnowledgeGroups"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertTrue(visitor.didVisitKnowledgeGroups)
    }
    
    func testCaseSensitivityDoesNotMatter() throws {
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/App/Web/kNoWlEdGeGroups"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertTrue(visitor.didVisitKnowledgeGroups)
    }

}
