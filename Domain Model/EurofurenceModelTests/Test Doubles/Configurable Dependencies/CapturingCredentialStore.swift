import EurofurenceModel
import Foundation

class CapturingCredentialStore: CredentialStore {

    init(persistedCredential: Credential? = nil) {
        self.persistedCredential = persistedCredential
    }

    private(set) var persistedCredential: Credential?

    private(set) var capturedCredential: Credential?
    var blockToRunBeforeCompletingCredentialStorage: (() -> Void)?
    func store(_ credential: Credential) {
        capturedCredential = credential
        persistedCredential = credential
        blockToRunBeforeCompletingCredentialStorage?()
    }

    private(set) var didDeletePersistedToken = false
    func deletePersistedToken() {
        didDeletePersistedToken = true
        persistedCredential = nil
    }

}
