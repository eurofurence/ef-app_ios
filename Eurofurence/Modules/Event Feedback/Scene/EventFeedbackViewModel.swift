import Foundation

protocol EventFeedbackViewModel {
    
    var eventTitle: String { get }
    var eventDayAndTime: String { get }
    var eventLocation: String { get }
    var eventHosts: String { get }
    
    func feedbackChanged(_ feedback: String)
    func ratingPercentageChanged(_ ratingPercentage: Float)
    func submitFeedback()
    
}
