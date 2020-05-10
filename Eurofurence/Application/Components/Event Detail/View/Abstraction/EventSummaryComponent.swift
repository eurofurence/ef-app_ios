import Foundation

protocol EventSummaryComponent {

    func setEventTitle(_ title: String)
    func setEventSubtitle(_ subtitle: String)
    func setEventAbstract(_ abstract: NSAttributedString)
    func setEventStartEndTime(_ startEndTime: String)
    func setEventLocation(_ location: String)
    func setTrackName(_ trackName: String)
    func setEventHosts(_ eventHosts: String)

}
