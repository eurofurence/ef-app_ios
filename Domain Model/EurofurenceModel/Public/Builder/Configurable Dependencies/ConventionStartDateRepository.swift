import Foundation

public protocol ConventionStartDateRepository {
    
    func addConsumer(_ consumer: ConventionStartDateConsumer)

}

public protocol ConventionStartDateConsumer {
    
    func conventionStartDateDidChange(to startDate: Date)
    
}
