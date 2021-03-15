import Foundation

public protocol UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool { get }

    func markTutorialAsComplete()

}
