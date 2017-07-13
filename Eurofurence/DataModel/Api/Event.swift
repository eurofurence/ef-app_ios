//
//  Event.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class Event: EntityBase {
	override class var DataModelVersion: Int { return 2 + super.DataModelVersion }

	var Abstract: String = ""
	var BannerImageId: String = ""
    var ConferenceDayId: String = ""
    var ConferenceTrackId: String = ""
    var ConferenceRoomId: String = ""
    var Description: String = ""
	var Duration: TimeInterval = 0.0
	var EndDateTimeUtc: Date = Date()
	var EndTime: String = ""
	var IsDeviatingFromConBook: Bool = false
    var PanelHosts: String = ""
	var PosterImageId: String = ""
    var Slug: String = ""
	var SubTitle: String = ""
	var StartDateTimeUtc: Date = Date()
	var StartTime: String = ""
    var Title: String = ""

	var _EventFavorite: EventFavorite?
	var IsFavorite: Bool {
		get { return _EventFavorite?.IsFavorite ?? false }
		set(value) { _EventFavorite?.IsFavorite = value }
	}

	weak var BannerImage: Image?
    weak var ConferenceDay: EventConferenceDay?
    weak var ConferenceTrack: EventConferenceTrack?
	weak var ConferenceRoom: EventConferenceRoom?
	weak var PosterImage: Image?

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "BannerImage", keyInResource: nil),
			        (keyInObject: "ConferenceDay", keyInResource: nil),
			        (keyInObject: "ConferenceTrack", keyInResource: nil),
			        (keyInObject: "ConferenceRoom", keyInResource: nil),
			        (keyInObject: "IsFavorite", keyInResource: nil),
			        (keyInObject: "PosterImage", keyInResource: nil),
			        (keyInObject: "_EventFavorite", keyInResource: nil)]
	}

	override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> Void), encodeConverter: (() -> Any?))] {
		return [
			(key: "Duration",
			 decodeConverter: {
				guard let timeString = $0 as? String else { return }
				self.Duration = TimeInterval.init(timeString: timeString) },
			 encodeConverter: { return "\(self.Duration.hoursPart):\(self.Duration.minutesPart):\(self.Duration.secondsPart)"})
		]
	}
}

extension Event: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? Event).map {
			return self.StartDateTimeUtc < $0.StartDateTimeUtc
			} ?? super.lessThan(rhs)
	}
}
