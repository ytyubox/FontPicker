//
/*
 *		Created by 游宗諭 in 2021/3/12
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import CoreData
import FontPicker

class AppFontStoreAdapter: FontStore, FontFileStore {
    let store = try! CoreDataFontStore(
        storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("font-store.sqlite"))
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        store.insert(data, for: url, completion: completion)
    }

    func retrieve(dataForURL url: URL, completion: @escaping (FontFileStore.RetrievalResult) -> Void) {
        store.retrieve(dataForURL: url, completion: completion)
    }

    func deleteCached(completion: @escaping DeletionCompletion) {
        store.deleteCached(completion: completion)
    }

    func insert(_ font: [LocalFont], timestamp: Date, completion: @escaping InsertionCompletion) {
        store.insert(font, timestamp: timestamp, completion: completion)
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        store.retrieve(completion: completion)
    }
}
