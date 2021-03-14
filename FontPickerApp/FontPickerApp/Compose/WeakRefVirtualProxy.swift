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
import LoadingSystem
import UIKit

// MARK: - Weak Proxy

final class WeakRefVirtualProxy<Object: AnyObject> {
    private weak var object: Object?

    init(_ object: Object) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FontLoadingView where Object: FontLoadingView {
    func display(_ viewModel: FontLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: UniversalView where Object: FontFileView, Object.FONT == UIFont {
    typealias Union = FontFileViewModel<Object.FONT>.VariantViewModel
}

extension WeakRefVirtualProxy: FontFileView where Object: FontFileView, Object.FONT == UIFont {
    typealias FONT = UIFont

    func display(_ viewModel: FontFileViewModel<Object.FONT>.VariantViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: FontErrorView where Object: FontErrorView {
    func display(_ viewModel: FontErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ItemsView where Object: ItemsView {
    func display(_ viewModel: ItemsViewModel<Object.Item>) {
        object?.display(viewModel)
    }

    
}

extension WeakRefVirtualProxy: FontView where Object: FontView  {
    
    func display(_ viewModel: ItemsViewModel<Font>) {
        object?.display(viewModel)
    }
    
    
}
