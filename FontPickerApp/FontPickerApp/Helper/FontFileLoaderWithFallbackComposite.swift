//
/*
 *		Created by 游宗諭 in 2021/1/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import FontPicker
import Foundation
import LoadingSystem
public class FontFileDataLoaderWithFallbackComposite: FontFileLoader {
    public typealias CancellableOutput = Data

    private class Task: CancellabelTask {
        func cancel() {}
    }

    let primary: AnyCancellableLoader<Data>
    let fallback: AnyCancellableLoader<Data>

    public init(primary: AnyCancellableLoader<Data>, fallback: AnyCancellableLoader<Data>) {
        self.primary = primary
        self.fallback = fallback
    }

    private class TaskWrapper: CancellabelTask {
        var wrapped: CancellabelTask?

        func cancel() {
            wrapped?.cancel()
        }
    }

    public func load(from url: URL, completion: @escaping Promise) -> CancellabelTask {
        let task = TaskWrapper()
        task.wrapped = primary.load(from: url) {
            [url, weak self, completion] primaryResult in
            switch primaryResult {
            case .success: completion(primaryResult)
            case .failure:
                task.wrapped = self?.fallback.load(from: url, completion: completion)
            }
        }
        return task
    }
}
