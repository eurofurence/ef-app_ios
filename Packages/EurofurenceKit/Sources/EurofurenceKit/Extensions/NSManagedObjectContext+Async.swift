import CoreData

extension NSManagedObjectContext {
    
    func performAsync<T>(block: @Sendable @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            perform { [self] in
                do {
                    let result = try block(self)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
