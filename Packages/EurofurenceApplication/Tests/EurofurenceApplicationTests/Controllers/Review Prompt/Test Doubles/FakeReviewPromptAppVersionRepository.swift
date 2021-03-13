import EurofurenceApplication
import EurofurenceModel
import Foundation

class FakeReviewPromptAppVersionRepository: ReviewPromptAppVersionRepository {

    var lastPromptedAppVersion: String?

    func setLastPromptedAppVersion(_ lastPromptedAppVersion: String) {
        print("*** Recording last prompted app version: \(lastPromptedAppVersion)")
        self.lastPromptedAppVersion = lastPromptedAppVersion
    }

}
