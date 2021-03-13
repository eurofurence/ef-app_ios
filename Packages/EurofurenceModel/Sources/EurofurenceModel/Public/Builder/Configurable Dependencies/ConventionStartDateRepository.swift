import Foundation

public protocol ConventionStartDateRepository {
    
    func addConsumer(_ consumer: ConventionStartDateConsumer)

}

public protocol ConventionStartDateConsumer: AnyObject {
    
    func conventionStartDateDidChange(to startDate: Date)
    
}
