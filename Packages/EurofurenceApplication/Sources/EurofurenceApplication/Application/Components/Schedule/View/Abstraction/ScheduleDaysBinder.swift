import Foundation

public protocol ScheduleDaysBinder {

    func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int)

}
