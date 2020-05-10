import Foundation

protocol ReviewPromptAppVersionRepository {

    var lastPromptedAppVersion: String? { get }
    func setLastPromptedAppVersion(_ lastPromptedAppVersion: String)

}
