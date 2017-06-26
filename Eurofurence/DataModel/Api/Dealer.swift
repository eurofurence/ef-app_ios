//
//  Dealer.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class Dealer: EntityBase {
    var AboutTheArtistText : String = ""
    var AboutTheArtText : String = ""
    var ArtistImageId : String = ""
    var ArtistThumbnailImageId : String = ""
    var ArtPreviewCaption : String = ""
    var ArtPreviewImageId : String = ""
	var AttendeeNickname : String = ""
	var AttendsOnFriday : Bool = true
	var AttendsOnSaturday : Bool = true
	var AttendsOnThursday : Bool = true
    var DisplayName : String = ""
	var Links : [LinkFragment] = []
	var Merchandise : String = ""
	var RegistrationNumber : String = ""
	var ShortDescription : String = ""
	var TwitterHandle : String = ""
	var TelegramHandle : String = ""
	
    var ArtistImage : Image?
	var ArtistThumbnailImage : Image?
	var ArtPreviewImage : Image?
	var MapEntry: MapEntry?
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "ArtistImage",keyInResource: nil),
			        (keyInObject: "ArtistThumbnailImage",keyInResource: nil),
			        (keyInObject: "ArtPreviewImage",keyInResource: nil)]
	}
}

extension Dealer: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? Dealer).map {
			return self.DisplayName < $0.DisplayName
			} ?? super.lessThan(rhs)
	}
}
