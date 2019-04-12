import Foundation

struct EF24StartDateRepository: ConventionStartDateRepository {

    var conventionStartDate: Date {
        let components = DateComponents(calendar: .current,
                                        timeZone: TimeZone(secondsFromGMT: 0)!,
                                        year: 2018,
                                        month: 8,
                                        day: 22)
        return components.date!
    }

}
