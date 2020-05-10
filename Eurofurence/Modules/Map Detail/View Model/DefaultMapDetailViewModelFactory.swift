import EurofurenceModel
import Foundation

class DefaultMapDetailViewModelFactory: MapDetailViewModelFactory, MapsObserver {

    private struct ViewModel: MapDetailViewModel {

        let map: Map
        
        var mapImagePNGData: Data
        
        var mapName: String {
            return map.location
        }

        func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor) {
            let contentHandler = ContentHandler(x: x, y: y, visitor: visitor)
            map.fetchContentAt(x: Int(x), y: Int(y), completionHandler: contentHandler.handle)
        }

    }

    private struct ContentHandler {

        var x: Float
        var y: Float
        var visitor: MapContentVisitor

        func handle(_ content: MapContent) {
            switch content {
            case .location(let altX, let altY, let name):
                let coordinate = MapCoordinate(x: altX, y: altY)
                if let name = name {
                    let contextualInfo = MapInformationContextualContent(coordinate: coordinate, content: name)
                    visitor.visit(contextualInfo)
                }
                visitor.visit(coordinate)

            case .room(let room):
                let coordinate = MapCoordinate(x: x, y: y)
                let contextualInfo = MapInformationContextualContent(coordinate: coordinate, content: room.name)
                visitor.visit(contextualInfo)

            case .dealer(let dealer):
                visitor.visit(dealer.identifier)

            case .multiple(let contents):
                visitor.visit(OptionsViewModel(contents: contents, handler: self))

            case .none:
                break
            }
        }

    }

    private struct OptionsViewModel: MapContentOptionsViewModel {

        private let contents: [MapContent]
        private let handler: ContentHandler

        init(contents: [MapContent], handler: ContentHandler) {
            self.contents = contents
            self.handler = handler
            optionsHeading = .selectAnOption
            options = contents.compactMap { (content) -> String? in
                switch content {
                case .room(let room):
                    return room.name

                case .dealer(let dealer):
                    return dealer.preferredName

                case .location(_, _, let name):
                    return name

                default:
                    return nil
                }
            }
        }

        var optionsHeading: String
        var options: [String]

        func selectOption(at index: Int) {
            let content = contents[index]
            handler.handle(content)
        }

    }

    private let mapsService: MapsService
    private var maps = [Map]()

    init(mapsService: MapsService) {
        self.mapsService = mapsService
        mapsService.add(self)
    }

    func makeViewModelForMap(identifier: MapIdentifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard let map = maps.first(where: { $0.identifier == identifier }) else { return }
        
        map.fetchImagePNGData { (mapGraphicData) in
            let viewModel = ViewModel(map: map, mapImagePNGData: mapGraphicData)
            completionHandler(viewModel)
        }
    }

    func mapsServiceDidChangeMaps(_ maps: [Map]) {
        self.maps = maps
    }

}
