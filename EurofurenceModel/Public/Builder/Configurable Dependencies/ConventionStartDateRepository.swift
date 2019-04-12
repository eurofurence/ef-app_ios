import Foundation

// TODO: Promote into fetching from remote config
// 1. Make acquiring start date async as-is (API change)
// 2. Add second adapter for fetching value from Firebase
public protocol ConventionStartDateRepository {

    var conventionStartDate: Date { get }

}
