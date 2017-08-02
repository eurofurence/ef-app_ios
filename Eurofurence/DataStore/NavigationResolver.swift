//
//  NavigationResolver.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class NavigationResolver: NavigationResolverProtocol {
	func resolve(dataContext: DataContextProtocol) {
		var linkFragments: [LinkFragment] = []

		print("\(#function): Resolving Dealers")
		dataContext.Dealers.modify({ value in
			for e in value {
				e.ArtistImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistImageId })
				e.ArtistThumbnailImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistThumbnailImageId })
				e.ArtPreviewImage = dataContext.Images.value.first(where: { $0.Id == e.ArtPreviewImageId })

				linkFragments.append(contentsOf: e.Links)
			}
		})

		print("\(#function): Resolving EventConferenceDays")
		dataContext.EventConferenceDays.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving EventConferenceRooms")
		dataContext.EventConferenceRooms.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving EventConferenceTracks")
		dataContext.EventConferenceTracks.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving Events")
		var eventFavorites: [EventFavorite] = []
		dataContext.Events.modify({ value in
			for e in value {
				e.BannerImage = dataContext.Images.value.first(where: { $0.Id == e.BannerImageId })
				e.PosterImage = dataContext.Images.value.first(where: { $0.Id == e.PosterImageId })

				e.ConferenceDay = dataContext.EventConferenceDays.value.first(where: { $0.Id == e.ConferenceDayId })
				e.ConferenceRoom = dataContext.EventConferenceRooms.value.first(where: { $0.Id == e.ConferenceRoomId })
				e.ConferenceTrack = dataContext.EventConferenceTracks.value.first(where: { $0.Id == e.ConferenceTrackId })

				e.ConferenceDay?.Events.append(e)
				e.ConferenceRoom?.Events.append(e)
				e.ConferenceTrack?.Events.append(e)

				e.EventFavorite = dataContext.EventFavorites.value.first(where: { $0.EventId == e.Id })
				if let eventFavorite = e.EventFavorite {
					eventFavorite.Event = e
					eventFavorites.append(eventFavorite)
				} else {
					let eventFavorite = EventFavorite(for: e)
					e.EventFavorite = eventFavorite
					eventFavorite.Event = e
					dataContext.EventFavorites.value.append(eventFavorite)
					eventFavorites.append(eventFavorite)
				}
			}
		})
		dataContext.EventFavorites.swap(eventFavorites)

		print("\(#function): Resolving KnowledgeGroups")
		dataContext.KnowledgeGroups.modify({ value in
			for e in value {
				e.KnowledgeEntries.removeAll()
			}
		})
		print("\(#function): Resolving KnowledgeEntries")
		dataContext.KnowledgeEntries.modify({ value in
			for e in value {
				e.KnowledgeGroup = dataContext.KnowledgeGroups.value.first(where: { $0.Id == e.KnowledgeGroupId })
				e.KnowledgeGroup?.KnowledgeEntries.append(e)

				if !e.ImageIds.isEmpty {
					let images = dataContext.Images.value.filter({e.ImageIds.contains($0.Id)})
					if !images.isEmpty {
						e.Images = images
					}
				}

				linkFragments.append(contentsOf: e.Links)
			}
		})

		print("\(#function): Resolving Maps")
		var mapEntries: [String:MapEntry] = [:]
		dataContext.Maps.modify({ value in
			for e in value {
				e.Image = dataContext.Images.value.first(where: { $0.Id == e.ImageId })

				for mapEntry in e.Entries {
					mapEntry.Map = e
					mapEntries[mapEntry.Id] = mapEntry
				}
			}

			for (_, mapEntry) in mapEntries {
				for link in mapEntry.Links {
					linkFragments.append(link)

					switch link.FragmentType {
					case .DealerDetail:
						if let dealer = dataContext.Dealers.value.first(where: { $0.Id == link.Target }) {
							dealer.MapEntry = mapEntry
							link.TargetObject = dealer
						}
					case .EventConferenceRoom:
						if let eventConferenceRoom = dataContext.EventConferenceRooms.value.first(where: { $0.Id == link.Target }) {
							eventConferenceRoom.MapEntry = mapEntry
						}
					default:
						break
					}
				}
			}
		})

		print("\(#function): Resolving LinkFragments")
		for link in linkFragments {
			switch link.FragmentType {
			case .MapExternal:
				// TODO: Geographic location on map for use with RoutingAppChooser
				break
			case .MapEntry:
				link.TargetObject = mapEntries[link.Target]
			default:
				break
			}
		}
	}
}
