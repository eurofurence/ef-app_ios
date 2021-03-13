import EurofurenceModel
import Foundation

class StubConventionStartDateRepository: ConventionStartDateRepository {

    var conventionStartDate: Date = Date()
    
    func addConsumer(_ consumer: ConventionStartDateConsumer) {
        consumer.conventionStartDateDidChange(to: conventionStartDate)
    }

}
