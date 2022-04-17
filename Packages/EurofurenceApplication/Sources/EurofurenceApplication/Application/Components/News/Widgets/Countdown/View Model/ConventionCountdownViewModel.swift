import ObservedObject

public protocol ConventionCountdownViewModel: ObservedObject {
    
    var showCountdown: Bool { get }
    var countdownDescription: String? { get }
    
}
