//
/*
 *		Created by 游宗諭 in 2021/1/7
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 10.15
 */

import FontPicker
import LoadingSystem

public class FontLoaderWithFallbackComposite: Loader {
    public typealias Output = [Font]

    private let primary: AnyLoader<Output>
    private let fallback: AnyLoader<Output>

    public init(primary: AnyLoader<Output>, fallback: AnyLoader<Output>) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load(completion: @escaping (AnyLoader<Output>.Outcome) -> Void) {
        primary.load {
            [fallback] primaryResult in
            switch primaryResult {
            case .success: completion(primaryResult)
            case .failure:
                fallback.load(completion: completion)
            }
        }
    }
}
