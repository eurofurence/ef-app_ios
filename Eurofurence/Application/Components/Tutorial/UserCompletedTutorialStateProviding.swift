import Foundation

protocol UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool { get }

    func markTutorialAsComplete()

}
