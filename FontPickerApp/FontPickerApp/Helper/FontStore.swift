//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation
import LoadingSystem

private class StoreBaseBox<L: LocalModel>: Store {
    func deleteCached(completion _: @escaping DeletionCompletion) {
        fatalError()
    }

    func insert(_: [L], timestamp _: Date, completion _: @escaping InsertionCompletion) {
        fatalError()
    }

    func retrieve(completion _: @escaping RetrievalCompletion) {
        fatalError()
    }

    typealias Local = L
}

private final class StoreBox<StoreType: Store>: StoreBaseBox<StoreType.Local> {
    let base: StoreType
    init(base: StoreType) {
        self.base = base
        super.init()
    }

    override func deleteCached(completion: @escaping DeletionCompletion) {
        base.deleteCached(completion: completion)
    }

    override func insert(_ font: [StoreType.Local], timestamp: Date, completion: @escaping InsertionCompletion) {
        base.insert(font, timestamp: timestamp, completion: completion)
    }

    override func retrieve(completion: @escaping RetrievalCompletion) {
        base.retrieve(completion: completion)
    }
}

public struct AnyStore<Local: LocalModel>: Store {
    private let box: StoreBaseBox<Local>

    public init<S: Store>(_ future: S) where Local == S.Local {
        if let earsed = future as? AnyStore<Local> {
            box = earsed.box
        } else {
            box = StoreBox(base: future)
        }
    }

    public func deleteCached(completion: @escaping DeletionCompletion) {
        box.deleteCached(completion: completion)
    }

    public func insert(_ font: [Local], timestamp: Date, completion: @escaping InsertionCompletion) {
        box.insert(font, timestamp: timestamp, completion: completion)
    }

    public typealias CompilableResult = (Result<CachedItem<Local>?, Error>) -> Void
    public func retrieve(completion: @escaping CompilableResult) {
        box.retrieve(completion: completion)
    }
}

public extension Store {
    func toAnyStore() -> AnyStore<Local> {
        AnyStore(self)
    }
}
