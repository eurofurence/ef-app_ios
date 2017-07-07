//
//  ImageServiceProtocol.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

protocol ImageServiceProtocol {
	init(dataContext: DataContextProtocol, apiConnection: ApiConnectionProtocol) throws
	func refreshCache(for images: [Image]) -> SignalProducer<Progress, ImageServiceError>
	func download(image: Image) -> SignalProducer<UIImage, ImageServiceError>
	func retrieve(for image: Image) -> SignalProducer<UIImage, ImageServiceError>
	func validateCache(for image: Image) -> Bool
	func clearCache(for image: Image)
	func clearCache(for imageId: String)
	func clearCache()
}

enum ImageServiceError: CustomNSError {
	case FailedConvert(image: Image, description: String?)
	case FailedCacheDirectory(url: URL, description: String?)
	case FailedDownload(image: Image, description: String?)
	case FailedRead(image: Image, description: String?)
	case FailedWrite(image: Image, description: String?)
	case InvalidParameter(functionName: String, description: String?)
	case NotImplemented(functionName: String)

	static var errorDomain: String {
		return "ImageServiceError"
	}

	var errorCode: Int {
		switch self {
		case .FailedConvert:
			return 4
		case .FailedCacheDirectory:
			return 2
		case .FailedDownload:
			return 3
		case .FailedRead:
			return 1
		case .FailedWrite:
			return 0
		case .InvalidParameter:
			return 400
		case .NotImplemented:
			return 501
		}
	}

	var errorUserInfo: [String: AnyObject] {
		switch self {
		case .FailedConvert(let image, let description):
			return ["message": "Image with ID \(image.Id) could not be converted" as NSString,
			        "description": (description ?? "") as NSString]
		case .FailedCacheDirectory(_, let description):
			return ["message": "Failed to create or access cache directory" as NSString,
			        "description": (description ?? "") as NSString]
		case .FailedDownload(let image, let description):
			return ["message": "Image with ID \(image.Id) failed to download from API" as NSString,
			        "description": (description ?? "") as NSString]
		case .FailedRead(let image, let description):
			return ["message": "Image with ID \(image.Id) could not be read from cache" as NSString,
			        "description": (description ?? "") as NSString]
		case .FailedWrite(let image, let description):
			return ["message": "Image with ID \(image.Id) could not be written to cache" as NSString,
			        "description": (description ?? "") as NSString]
		case .InvalidParameter(let functionName, let description):
			return ["message": "Invalid parameter for function \(functionName)" as NSString,
			        "description": (description ?? "") as NSString]
		case .NotImplemented(let functionName):
			return ["message": "Function \(functionName) is not (yet) implemented" as NSString,
			        "description": "" as NSString]
		}
	}
}
