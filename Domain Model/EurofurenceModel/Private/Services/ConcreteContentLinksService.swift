import EventBus
import Foundation

class ConcreteContentLinksService: ContentLinksService, EventConsumer {

    private var externalContentHandler: ExternalContentHandler?
    private let urlOpener: URLOpener?
    private let eventsService: EventsService
    private let dealersService: DealersService

    init(eventBus: EventBus,
         urlOpener: URLOpener?,
         eventsService: EventsService,
         dealersService: DealersService) {
        self.urlOpener = urlOpener
        self.eventsService = eventsService
        self.dealersService = dealersService
        
        eventBus.subscribe(consumer: self)
    }

    func consume(event: DomainEvent.OpenURL) {
        let url = event.url

        if let urlOpener = urlOpener, urlOpener.canOpen(url) {
            urlOpener.open(url)
        } else {
            externalContentHandler?.handleExternalContent(url: url)
        }
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        self.externalContentHandler = externalContentHandler
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }
    
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor) {
        URLEntityProcessor(eventsService: eventsService, dealersService: dealersService).process(url, visitor: visitor)
    }
    
    private struct URLEntityProcessor {
        
        var eventsService: EventsService
        var dealersService: DealersService
        
        func process(_ url: URL, visitor: URLContentVisitor) {
            let identifierComponent = url.lastPathComponent
            
            let eventIdentifier = EventIdentifier(identifierComponent)
            if eventsService.fetchEvent(identifier: eventIdentifier) != nil {
                visitor.visit(EventIdentifier(identifierComponent))
            }
            
            let dealerIdentifier = DealerIdentifier(identifierComponent)
            if dealersService.fetchDealer(for: dealerIdentifier) != nil {
                visitor.visit(dealerIdentifier)
            }
        }
        
    }

}
