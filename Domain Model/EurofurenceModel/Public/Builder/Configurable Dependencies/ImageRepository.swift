import Foundation

public protocol ImageRepository {

    func save(_ image: ImageEntity)
    func deleteEntity(identifier: String)
    func loadImage(identifier: String) -> ImageEntity?
    func containsImage(identifier: String) -> Bool

}
