import EurofurenceModel
import XCTest

class AddingAdditionalServicesConsumer_WhileLoggedOut: XCTestCase {

    func testShouldProvideURLToConsumer() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let context = EurofurenceSessionTestBuilder().with(additionalServicesRequestFactory).build()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        
        XCTAssertEqual(consumer.consumedAdditionalServicesURLRequest, additionalServicesRequestFactory.additionalServicesRequest)
    }

}
