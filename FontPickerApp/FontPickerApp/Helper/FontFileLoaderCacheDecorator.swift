//
/*
 *		Created by 游宗諭 in 2021/1/19
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import FontPicker
import Foundation
import LoadingSystem
protocol FontFileLoader: CancellableLoader where CancellableOutput == Data {}

public class FontFileDataLoaderCacheDecorator: FontFileLoader {
    public typealias CancellableOutput = Data

    public init(decoratee: AnyCancellableLoader<Data>,
                cache: LocalFontFileLoader)
    {
        self.decoratee = decoratee
        self.cache = cache
    }

    private let decoratee: AnyCancellableLoader<Data>
    fileprivate let cache: LocalFontFileLoader

    public func load(from url: URL, completion: @escaping (Outcome) -> Void) -> CancellabelTask {
        decoratee.load(from: url) {
            [url, completion, unowned self] loadResult in

            completion(
                loadResult
                    .map { [url] data in
                        saveIgnoringResult(data, for: url)
                        return data
                    }
            )
        }
    }
}

private extension FontFileDataLoaderCacheDecorator {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        cache.save(data, for: url) { _ in }
    }
}
