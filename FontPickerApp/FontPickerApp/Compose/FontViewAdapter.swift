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

private typealias Proxy = WeakRefVirtualProxy<FontCellController>

final class FontViewAdapter: FontView {
    private unowned var controller: FontViewController?
    private let fontFileLoader: AnyCancellableLoader<Data>
    private let fontMaker = UIFontMaker()
    init(controller: FontViewController,
         fontFileLoader: AnyCancellableLoader<Data>)
    {
        self.controller = controller
        self.fontFileLoader = fontFileLoader
    }

    func display(_ viewModel: FontViewModel) {
        controller?.display(
            viewModel.items.map {
                font in

                FontGroupController(
                    name: font.name,
                    tableModel:
                    font.variants.map {
                        variant in
                        let adapt = FontFilePresentationAdapter<Proxy, UIFont>(
                            fontFileDataLoader: fontFileLoader,
                            model: variant,
                            url: variant.fileURL
                        )
                        let view = FontCellController(delegate: adapt, demoText: font.name)
                        adapt.presenter = FontFilePresenter(
                            view: WeakRefVirtualProxy(view),
                            fontTransformer: {
                                [fontMaker]
                                data in
                                try
                                    fontMaker.build(url: variant.fileURL, data: data)
                            }
                        )
                        return view
                    }
                )
            }
        )
    }
}
