import Foundation

public protocol Clock {

    var currentDate: Date { get }
    func setDelegate(_ delegate: ClockDelegate)

}

public protocol ClockDelegate {

    func clockDidTick(to time: Date)

}
