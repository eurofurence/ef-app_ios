import Foundation

extension String {
    
    static func additionalEventsFooter(remaining: Int) -> String {
        let format = NSLocalizedString(
            "AdditionalEventsFooterFormat",
            comment: "Footer at the bottom of the large events widget for the number of events not shown in the widget"
        )
        
        return String.localizedStringWithFormat(format, remaining)
    }
    
}
