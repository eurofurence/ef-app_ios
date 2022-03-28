import EurofurenceApplication
import EurofurenceModel

class CapturingNewsComponentHeaderScene: NewsComponentHeaderScene {

    private(set) var capturedTitle: String?
    func setComponentTitle(_ title: String?) {
        capturedTitle = title
    }

}
