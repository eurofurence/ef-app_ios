import EurofurenceModel
import Foundation

class CapturingConventionCountdownServiceObserver: ConventionCountdownServiceObserver {

    private(set) var capturedDaysRemaining: Int?
    private(set) var toldCountdownDidElapse = false
    func conventionCountdownStateDidChange(to state: ConventionCountdownState) {
        switch state {
        case .countingDown(let daysRemaining):
            capturedDaysRemaining = daysRemaining

        case .countdownElapsed:
            toldCountdownDidElapse = true
        }
    }

}
