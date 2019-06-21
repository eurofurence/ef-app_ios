import EurofurenceModel
import XCTest

class AddingAdditionalServicesConsumer_AfterLoggingOut: XCTestCase {

    func testShouldProvideUnauthenticatedURLToConsumer() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let credential = Credential(username: .random,
                                    registrationNumber: .random,
                                    authenticationToken: .random,
                                    tokenExpiryDate: .random)
        let context = EurofurenceSessionTestBuilder().with(credential).with(additionalServicesRequestFactory).build()
        context.logoutSuccessfully()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        
        XCTAssertEqual(consumer.consumedAdditionalServicesURLRequest, additionalServicesRequestFactory.unauthenticatedAdditionalServicesRequest)
    }

}
