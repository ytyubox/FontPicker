//
/*
 *		Created by 游宗諭 in 2020/12/22
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import FontPicker
import FontPickeriOS
import Foundation
import LoadingSystem

// MARK: - redirect to Main queue if need

final class MainQueueDispatchDecorator<Decoratee> {
    private let decoratee: Decoratee

    init(decoratee: Decoratee) {
        self.decoratee = decoratee
    }

    func dispatchIfNeed(execute work: @escaping () -> Void) {
        guard Thread.isMainThread
        else {
            DispatchQueue.main.async {
                work()
            }
            return
        }
        work()
    }
}

extension MainQueueDispatchDecorator: Loader where Decoratee == AnyLoader<[Font]> {}

extension MainQueueDispatchDecorator: FontLoader where Decoratee == AnyLoader<[Font]> {
    typealias CompilableFontResult = Result<[Font], Error>
    func load(completion: @escaping (CompilableFontResult) -> Void) {
        decoratee.load {
            [weak self] result in
            self?.dispatchIfNeed {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: CancellableLoader where Decoratee == AnyCancellableLoader<Data> {}

extension MainQueueDispatchDecorator: FontFileLoader where Decoratee == AnyCancellableLoader<Data> {
    typealias CompilableDataResult = Result<Data, Error>
    func load(from url: URL, completion: @escaping (CompilableDataResult) -> Void) -> CancellabelTask {
        decoratee.load(from: url) {
            [weak self] r in
            self?.dispatchIfNeed {
                completion(r)
            }
        }
    }
}
