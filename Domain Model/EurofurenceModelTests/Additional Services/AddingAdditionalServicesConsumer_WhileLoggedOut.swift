import EurofurenceModel
import XCTest

class AddingAdditionalServicesConsumer_WhileLoggedOut: XCTestCase {

    func testShouldProvideUnauthenticatedURLToConsumer() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let context = EurofurenceSessionTestBuilder().with(additionalServicesRequestFactory).build()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        
        XCTAssertEqual(
            consumer.consumedAdditionalServicesURLRequest,
            additionalServicesRequestFactory.unauthenticatedAdditionalServicesRequest
        )
    }
    
    func testLoggingInUpdatesConsumerWithAuthenticatedURL() {
        let additionalServicesRequestFactory = StubCompanionAppURLRequestFactory()
        let context = EurofurenceSessionTestBuilder().with(additionalServicesRequestFactory).build()
        let consumer = CapturingAdditionalServicesURLConsumer()
        context.additionalServicesRepository.add(consumer)
        context.loginSuccessfully()
        
        XCTAssertEqual(
            consumer.consumedAdditionalServicesURLRequest, 
            additionalServicesRequestFactory.authenticatedAdditionalServicesRequest
        )
        
        XCTAssertEqual(
            context.authenticationToken, 
            additionalServicesRequestFactory.additionalServicesAuthenticationToken
        )
    }

}
