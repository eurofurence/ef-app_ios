import Foundation

struct EF24StartDateRepository: ConventionStartDateRepository {

    var conventionStartDate: Date {
        guard let timeZone = TimeZone(secondsFromGMT: 0) else { fatalError("Why is the GMT gone?") }
        let components = DateComponents(calendar: .current,
                                        timeZone: timeZone,
                                        year: 2018,
                                        month: 8,
                                        day: 22)
        
        guard let date = components.date else { fatalError("Unable to produce date from components: \(components)") }
        return date
    }

}
