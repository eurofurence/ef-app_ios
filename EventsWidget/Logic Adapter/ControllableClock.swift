import EurofurenceModel
import Foundation.NSDate

class ControllableClock: Clock {
    
    var currentDate: Date = Date()
    
    func setDelegate(_ delegate: ClockDelegate) { }
    
}
