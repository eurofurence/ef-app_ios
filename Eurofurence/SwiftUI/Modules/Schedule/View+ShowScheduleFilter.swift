import SwiftUI

extension View {
    
    func showScheduleFilter(_ show: Bool) -> some View {
        self
            .environment(\.showScheduleFilterButton, show)
    }
    
}

extension EnvironmentValues {
    
    var showScheduleFilterButton: Bool {
        get {
            self[ShowScheduleFilterButtonEnvironmentKey.self]
        }
        set {
            self[ShowScheduleFilterButtonEnvironmentKey.self] = newValue
        }
    }
    
    private struct ShowScheduleFilterButtonEnvironmentKey: EnvironmentKey {
        
        typealias Value = Bool
        
        static var defaultValue = true
        
    }
    
}
