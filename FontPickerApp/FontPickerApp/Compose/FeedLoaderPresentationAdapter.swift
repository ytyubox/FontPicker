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
final class FontLoaderPresentationAdapter<View: FontView>: FontViewControllerDelegate {
    private let fontLoader: AnyLoader<[Font]>

    init(fontLoader: AnyLoader<[Font]>) {
        self.fontLoader = fontLoader
    }

    var presenter: FontPresenter<View>!

    func didRequestRefresh() {
        presenter.didStartLoading()

        fontLoader.load { [weak self] result in
            switch result {
            case let .success(font):
                self?.presenter.didFinishLoading(with: font)

            case let .failure(error):
                self?.presenter.didFinishLoading(with: error)
            }
        }
    }
}
