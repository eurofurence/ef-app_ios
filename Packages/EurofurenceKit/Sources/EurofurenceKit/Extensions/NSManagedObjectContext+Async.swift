import CoreData

extension NSManagedObjectContext {
    
    func performAsync<T>(block: @Sendable @escaping () throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            perform {
                do {
                    let result = try block()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
