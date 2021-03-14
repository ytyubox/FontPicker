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

protocol FontLoader: Loader where Output == [Font] {}

public final class FontLoaderCacheDecorator<C: FontCache>: FontLoader {
    private let decoratee: AnyLoader<[Font]>
    private let cache: C

    public init(decoratee: AnyLoader<[Font]>, cache: C) {
        self.decoratee = decoratee
        self.cache = cache
    }

    public typealias CompileOutputResult = Result<[Font], Error>
    public func load(completion: @escaping (CompileOutputResult) -> Void) {
        decoratee.load {
            [completion] loadResult in
            completion(
                loadResult.map {
                    font in
                    self.saveIgnoringResult(font)
                    return font
                }
            )
        }
    }

    fileprivate func saveIgnoringResult(_ font: [Font]) {
        cache.save(font) { _ in }
    }
}
