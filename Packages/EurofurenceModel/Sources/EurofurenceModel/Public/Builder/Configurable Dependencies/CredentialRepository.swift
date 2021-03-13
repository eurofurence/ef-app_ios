public protocol CredentialRepository {

    var persistedCredential: Credential? { get }

    func store(_ credential: Credential)
    func deletePersistedToken()

}
