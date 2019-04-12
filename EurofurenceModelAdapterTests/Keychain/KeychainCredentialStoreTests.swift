import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KeychainCredentialStoreTests: XCTestCase {

    private func makeStore() -> KeychainCredentialStore {
        return KeychainCredentialStore(userAccount: "Eurofurence.Test")
    }

    func testStoringLoginShouldRetainItBetweenLifetimes() {
        var store = makeStore()
        let credential = Credential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store = makeStore()

        let persistedCredential: Credential? = store.persistedCredential
        XCTAssertEqual(credential.username, persistedCredential?.username)
        XCTAssertEqual(credential.registrationNumber, persistedCredential?.registrationNumber)
        XCTAssertEqual(credential.authenticationToken, persistedCredential?.authenticationToken)
        XCTAssertEqual(credential.tokenExpiryDate, persistedCredential?.tokenExpiryDate)
    }

    func testStoringLoginThenDeletingItShouldReturnNilToken() {
        let store = makeStore()
        let credential = Credential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store.deletePersistedToken()

        XCTAssertNil(store.persistedCredential)
    }

}
