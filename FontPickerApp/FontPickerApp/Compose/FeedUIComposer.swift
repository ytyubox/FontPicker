/**
 * Created by 游宗諭 in 2020/12/16
 *
 *
 * Using Swift 5.0
 *
 * Running on macOS 10.15
 */

import FontPicker
import FontPickeriOS
import LoadingSystem
import UIKit

enum FontUIComposer {
    static func fontComposedWith(fontLoader: AnyLoader<[Font]>, fontFileLoader: AnyCancellableLoader<Data>) -> FontViewController {
        let fontLoader_alwaysOnMain = MainQueueDispatchDecorator(decoratee: fontLoader).toAnyLoader()
        let fontFileLoader_alwaysOnMain = MainQueueDispatchDecorator(decoratee: fontFileLoader).toAnyCancellableLoader()

        let fontLoaderPresentationAdapter = FontLoaderPresentationAdapter<FontViewAdapter>(fontLoader: fontLoader_alwaysOnMain)
        let fontController = createFontViewController(
            delegate: fontLoaderPresentationAdapter,
            title: FontPresenter<AnyFontVIew>.title
        )

        fontLoaderPresentationAdapter.presenter =
            FontPresenter(
                fontView: FontViewAdapter(
                    controller: fontController,
                    fontFileLoader: fontFileLoader_alwaysOnMain
                ),
                loadingView: WeakRefVirtualProxy(fontController),
                errorView: WeakRefVirtualProxy(fontController)
            )
        return fontController
    }

    // MARK: - Factory

    private static func createFontViewController(
        delegate: FontViewController.Delegate,
        title: String
    ) -> FontViewController {
        let bundle = Bundle(for: FontViewController.self)
        let storyboard = UIStoryboard(name: "Font", bundle: bundle)
        let object = storyboard.instantiateInitialViewController() as! FontViewController
        object.title = title
        object.delegate = delegate
        return object
    }
}

class AnyFontVIew: FontView {
    func display(_: ItemsViewModel<Font>) {}
}
