//
//  DefaultMapDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultMapDetailInteractor: MapDetailInteractor, MapsObserver {

    private struct ViewModel: MapDetailViewModel {

        var mapsService: MapsService
        var mapIdentifier: Map2.Identifier
        var mapImagePNGData: Data
        var mapName: String

        func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor) {
            let contentHandler = ContentHandler(x: x, y: y, visitor: visitor)
            mapsService.fetchContent(for: mapIdentifier, atX: Int(x), y: Int(y), completionHandler: contentHandler.handle)
        }

        private struct ContentHandler {

            var x: Float
            var y: Float
            var visitor: MapContentVisitor

            func handle(_ content: Map2.Content) {
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

            private let contents: [Map2.Content]
            private let handler: ContentHandler

            init(contents: [Map2.Content], handler: ContentHandler) {
                self.contents = contents
                self.handler = handler
                optionsHeading = .selectAnOption
                options = contents.compactMap { (content) -> String? in
                    switch content {
                    case .room(let room):
                        return room.name

                    case .dealer(let dealer):
                        return dealer.preferredName

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

    }

    private let mapsService: MapsService
    private var maps = [Map2]()

    convenience init() {
        self.init(mapsService: EurofurenceApplication.shared)
    }

    init(mapsService: MapsService) {
        self.mapsService = mapsService
        mapsService.add(self)
    }

    func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard let map = maps.first(where: { $0.identifier == identifier }) else { return }

        mapsService.fetchImagePNGDataForMap(identifier: identifier) { (mapGraphicData) in
            let viewModel = ViewModel(mapsService: self.mapsService,
                                      mapIdentifier: identifier,
                                      mapImagePNGData: mapGraphicData,
                                      mapName: map.location)
            completionHandler(viewModel)
        }
    }

    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        self.maps = maps
    }

}
