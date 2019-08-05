import EurofurenceModel
import XCTest

class WhenDescribingKnowledgeGroupsLink: XCTestCase {

    func testTheKnowledgeGroupsContentIsProvided() {
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/App/Web/KnowledgeGroups"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertTrue(visitor.didVisitKnowledgeGroups)
    }
    
    func testCaseSensitivityDoesNotMatter() {
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/App/Web/kNoWlEdGeGroups"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertTrue(visitor.didVisitKnowledgeGroups)
    }

}
