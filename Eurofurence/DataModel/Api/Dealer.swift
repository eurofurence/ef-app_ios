//
//  Dealer.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class Dealer: EntityBase {
    var AboutTheArtistText : String = ""
    var AboutTheArtText : String = ""
    var ArtistImageId : UUID? = nil
    var ArtistThumbnailImageId : UUID? = nil
    var ArtPreviewCaption : String = ""
    var ArtPreviewImageId : UUID? = nil
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
}

extension Dealer : Comparable {
	static func < (lhs: Dealer, rhs: Dealer) -> Bool {
		return lhs.DisplayName < rhs.DisplayName
	}
}
