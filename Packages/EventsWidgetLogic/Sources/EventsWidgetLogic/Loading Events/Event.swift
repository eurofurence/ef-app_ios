import Foundation

public protocol Event {
    
    var id: String { get }
    var title: String { get }
    var startTime: Date { get }
    var endTime: Date { get }
    
}
