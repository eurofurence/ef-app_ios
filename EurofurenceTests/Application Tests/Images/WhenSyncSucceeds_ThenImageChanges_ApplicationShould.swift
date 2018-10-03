//
//  WhenSyncSucceeds_ThenImageChanges_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class WhenSyncSucceeds_ThenImageChanges_ApplicationShould: XCTestCase {
    
    func testRedownloadTheImage() {
        class VerifyImageRedownloadedAPI: FakeImageAPI {
            
            func verifyDownloadedImage(identifier: String, count: Int, file: StaticString = #file, line: UInt = #line) {
                let actualCount = downloadedImageIdentifiers.filter({ $0 == identifier }).count
                XCTAssertEqual(count, actualCount, file: file, line: line)
            }
            
        }
        
        let imageAPI = VerifyImageRedownloadedAPI()
        let context = ApplicationTestBuilder().with(imageAPI).build()
        let originalResponse = APISyncResponse.randomWithoutDeletions
        var subsequentResponse = originalResponse
        let changedImage = originalResponse.images.changed.randomElement()
        subsequentResponse.images.changed = [changedImage.element]
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        
        imageAPI.verifyDownloadedImage(identifier: changedImage.element.identifier, count: 2)
    }
    
}
