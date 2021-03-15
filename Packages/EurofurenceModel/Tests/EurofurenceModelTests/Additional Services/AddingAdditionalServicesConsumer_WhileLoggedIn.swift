import EurofurenceModel
import XCTest

class AddingAdditionalServicesConsumer_WhileLoggedIn: XCTestCase {

    func testShouldProvideAuthenticatedURLToConsumer() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let credential = Credential.randomValidCredential
        let context = EurofurenceSessionTestBuilder().with(credential).with(additionalServicesRequestFactory).build()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        
        XCTAssertEqual(
            consumer.consumedAdditionalServicesURLRequest,
            additionalServicesRequestFactory.authenticatedAdditionalServicesRequest
        )
        
        XCTAssertEqual(
            credential.authenticationToken,
            additionalServicesRequestFactory.additionalServicesAuthenticationToken
        )
    }
    
    func testLoggingOutUpdatesConsumerWithUnauthenticatedURL() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let credential = Credential.randomValidCredential
        let context = EurofurenceSessionTestBuilder().with(credential).with(additionalServicesRequestFactory).build()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        context.logoutSuccessfully()
        
        XCTAssertEqual(
            consumer.consumedAdditionalServicesURLRequest,
            additionalServicesRequestFactory.unauthenticatedAdditionalServicesRequest
        )
    }

}
