//
//  NavigationResolver.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class NavigationResolver: INavigationResolver {
	func resolve(dataContext: IDataContext) {
		// TODO: Resolve links to MapEntry
		dataContext.Dealers.modify({ value in
			for e in value {
				e.ArtistImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistImageId })
				e.ArtistThumbnailImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistThumbnailImageId })
				e.ArtPreviewImage = dataContext.Images.value.first(where: { $0.Id == e.ArtPreviewImageId })
			}
		})

		dataContext.EventConferenceDays.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		dataContext.EventConferenceRooms.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		dataContext.EventConferenceTracks.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		dataContext.Events.modify({ value in
			for e in value {
				e.ConferenceDay = dataContext.EventConferenceDays.value.first(where: { $0.Id == e.ConferenceDayId })
				e.ConferenceRoom = dataContext.EventConferenceRooms.value.first(where: { $0.Id == e.ConferenceRoomId })
				e.ConferenceTrack = dataContext.EventConferenceTracks.value.first(where: { $0.Id == e.ConferenceTrackId })

				e.ConferenceDay?.Events.append(e)
				e.ConferenceRoom?.Events.append(e)
				e.ConferenceTrack?.Events.append(e)
			}
		})


		dataContext.KnowledgeGroups.modify({ value in
			for e in value {
				e.KnowledgeEntries.removeAll()
			}
		})
		dataContext.KnowledgeEntries.modify({ value in
			for e in value {
				e.KnowledgeGroup = dataContext.KnowledgeGroups.value.first(where: { $0.Id == e.KnowledgeGroupId })
				e.KnowledgeGroup?.KnowledgeEntries.append(e)
			}
		})

		dataContext.Maps.modify({ value in
			for e in value {
				e.Image = dataContext.Images.value.first(where: { $0.Id == e.ImageId })

				for mapEntry in e.Entries {
					mapEntry.Map = e
				}
			}
		})
	}
}
