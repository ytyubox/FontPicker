

import CoreData
import LoadingSystem
extension CoreDataFontStore: FontStore {
    public typealias Local = LocalFont

    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { (context: NSManagedObjectContext) in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    CachedItem(item: $0.localFont, timestamp: $0.timestamp)
                }
            })
        }
    }

    public func insert(_ local: [Local], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.font = ManagedFont.fonts(from: local, in: context)
                try context.save()
            })
        }
    }

    public func deleteCached(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
}
