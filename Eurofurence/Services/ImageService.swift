//
//  ImageService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Alamofire
import Foundation
import FirebasePerformance
import ReactiveSwift
import Result
import UIKit

class ImageService: ImageServiceProtocol {
	private static let cacheDirectoryName = "Cache"
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.ImageService")
	private var disposables = CompositeDisposable()
	private let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	private var cacheDirectory: URL
	private let apiConnection: ApiConnectionProtocol
	private var refreshTrace: Trace?

	required init(dataContext: DataContextProtocol, apiConnection: ApiConnectionProtocol) throws {
		cacheDirectory = baseDirectory.appendingPathComponent(ImageService.cacheDirectoryName, isDirectory: true)
		self.apiConnection = apiConnection

		try checkCacheDirectory()
	}

	/// Checks the existence of and if necessary creates the cache directory.
	/// Should be called before doing any I/O operations.
	private func checkCacheDirectory() throws {
		if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
				try cacheDirectory.setExcludedFromBackup(true)
			} catch {
				throw ImageServiceError.FailedCacheDirectory(url: cacheDirectory,
				                                     description: "Attempted to create and exclude cache directory from backup.")
			}
		}
	}

	func refreshCache(for images: [Image]) -> SignalProducer<Progress, ImageServiceError> {
		return SignalProducer { [unowned self] observer, disposable in
			self.refreshTrace = Performance.startTrace(name: "ImageService.refreshCache")
			self.refreshTrace?.incrementCounter(named: "total", by: images.count)
			do {
				try self.checkCacheDirectory()
				var currentCache: [String] = try FileManager.default.contentsOfDirectory(atPath: self.cacheDirectory.path)

				var producers: [SignalProducer<UIImage, ImageServiceError>] = []
				for image in images {
					if !self.validateCache(for: image) {
						self.refreshTrace?.incrementCounter(named: "scheduled")
						producers.append(self.download(image: image))
					}
					if let index = currentCache.index(of: image.Id) {
						currentCache.remove(at: index)
					}
				}

				let progress = Progress(totalUnitCount: Int64(producers.count + 2))
				progress.completedUnitCount += 1
				observer.send(value: progress)

				for imageId in currentCache {
					self.clearCache(for: imageId)
					self.refreshTrace?.incrementCounter(named: "pruned")
					print("Pruned image \(imageId) from cache.")
				}
				progress.completedUnitCount += 1
				observer.send(value: progress)

				let resultsProducer = SignalProducer<SignalProducer<UIImage, ImageServiceError>, NoError>(producers)
				disposable += resultsProducer.flatten(.merge).start({ event in
					switch event {
					case .value:
						self.refreshTrace?.incrementCounter(named: "downloaded")
						progress.completedUnitCount += 1
						observer.send(value: progress)
						print("Image caching completed by \(progress.fractionCompleted)")
					case let .failed(error):
						print("Error while caching images from sync: \(error)")
						self.refreshTrace?.stop()
						self.refreshTrace = nil
						observer.send(error: error)
					case .completed:
						print("Finished caching images from sync")
						self.refreshTrace?.stop()
						self.refreshTrace = nil
						observer.sendCompleted()
					case .interrupted:
						print("Caching images from sync interrupted")
						self.refreshTrace?.stop()
						self.refreshTrace = nil
						observer.sendInterrupted()
					}
				})
			} catch let error as ImageServiceError {
				self.refreshTrace?.stop()
				self.refreshTrace = nil
				observer.send(error: error)
			} catch {
				self.refreshTrace?.stop()
				self.refreshTrace = nil
				observer.send(error: ImageServiceError.FailedCacheDirectory(url: self.cacheDirectory, description: nil))
			}
		}
	}

	func download(image: Image) -> SignalProducer<UIImage, ImageServiceError> {
		return SignalProducer { [unowned self] observer, disposable in
			do {
				try self.checkCacheDirectory()
				disposable += self.apiConnection.downloadImage(for: image).observe(on: self.scheduler).startWithResult({ result in
					switch result {
					case let .success(value):
						do {
							try self.store(value, for: image)
							observer.send(value: value)
						} catch let error as ImageServiceError {
							print(error)
							//observer.send(error: error)
						} catch {}
						observer.sendCompleted()
					case let .failure(error):
						/*observer.send(error: ImageServiceError.FailedDownload(image: image,
																			  description: error.localizedDescription))*/
						let imageServiceError = ImageServiceError.FailedDownload(image: image,
						                                                         description: error.localizedDescription)
						print(imageServiceError)
						if let refreshTrace = self.refreshTrace {
							refreshTrace.incrementCounter(named: "failed")
						}
						observer.sendCompleted()
					}
				})
			} catch let error as ImageServiceError {
				observer.send(error: error)
			} catch {
				observer.send(error: ImageServiceError.FailedCacheDirectory(url: self.cacheDirectory, description: nil))
			}
		}
	}

	func retrieve(for image: Image) -> SignalProducer<UIImage, ImageServiceError> {
		return SignalProducer { [unowned self] observer, disposable in
			if self.validateCache(for: image) {
				do {
					let uiImage = try self.load(image)
					observer.send(value: uiImage)
					observer.sendCompleted()
				} catch let error as ImageServiceError {
					observer.send(error: error)
				} catch {}
			} else {
				disposable += self.download(image: image).startWithResult({ result in
					switch result {
					case let .success(value):
						observer.send(value: value)
					case let .failure(error):
						observer.send(error: error)
					}
				})
			}
		}.start(on: scheduler)
	}

	func validateCache(for image: Image) -> Bool {
		do {
			let imageUrl = getUrl(for: image)
			let imageAttributes = try imageUrl.resourceValues(forKeys: [.isRegularFileKey, .isReadableKey, .fileSizeKey, .contentModificationDateKey])

			guard let isRegularFile = imageAttributes.isRegularFile, isRegularFile else {
				return false
			}

			guard let isReadable = imageAttributes.isReadable, isReadable else {
				return false
			}

			guard let fileSize = imageAttributes.fileSize, fileSize != image.SizeInBytes else {
				clearCache(for: image)
				return false
			}

			guard let modificationDate = imageAttributes.contentModificationDate,
					modificationDate.addingTimeInterval(1) >= image.LastChangeDateTimeUtc else {
				clearCache(for: image)
				return false
			}

			// TODO: Check if SHA1-hash matches

			return true
		} catch {
			return false
		}
	}

	func clearCache(for image: Image) {
		do {
			try FileManager.default.removeItem(at: getUrl(for: image))
		} catch {
			/* */
		}
	}

	func clearCache(for imageId: String) {
		do {
			try FileManager.default.removeItem(at: cacheDirectory.appendingPathComponent(imageId, isDirectory: false))
		} catch {
			/* */
		}
	}

	func clearCache() {
		do {
			try FileManager.default.removeItem(at: cacheDirectory)
		} catch {
			/* */
		}
	}

	private func getUrl(for image: Image) -> URL {
		return cacheDirectory.appendingPathComponent(image.Id, isDirectory: false)
	}

	private func load(_ image: Image) throws -> UIImage {
		do {
			let imageUrl = getUrl(for: image)
			let imageData = try Data(contentsOf: imageUrl)
			guard let uiImage = UIImage(data: imageData) else {
				throw ImageServiceError.FailedRead(image: image, description: "Attempted to create UIImage from data retrieved from cache.")
			}
			return uiImage
		} catch let error as ImageServiceError {
			throw error
		} catch {
			throw ImageServiceError.FailedRead(image: image, description: nil)
		}
	}

	private func store(_ uiImage: UIImage, for image: Image) throws {
		do {
			guard let imageData = UIImagePNGRepresentation(uiImage) else {
				throw ImageServiceError.FailedConvert(image: image, description: "Attempted to convert UIImage to PNG representation.")
			}
			var imageUrl = getUrl(for: image)
			try imageData.write(to: imageUrl)
			try imageUrl.setExcludedFromBackup(true)
			var urlResourceValues = URLResourceValues()
			urlResourceValues.contentModificationDate = image.LastChangeDateTimeUtc
			try imageUrl.setResourceValues(urlResourceValues)
		} catch {
			throw ImageServiceError.FailedWrite(image: image, description: "Attempted to write image to cache and exclude it from backup.")
		}
	}
}
