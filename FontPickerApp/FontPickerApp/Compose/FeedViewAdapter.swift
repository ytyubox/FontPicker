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

final class FontViewAdapter: FontView {
    private unowned var controller: FontViewController?
    private let fontFileLoader: AnyCancellableLoader<Data>

    init(controller: FontViewController,
         fontFileLoader: AnyCancellableLoader<Data>)
    {
        self.controller = controller
        self.fontFileLoader = fontFileLoader
    }

    func display(_: FontViewModel) {
//        controller?.display(
//            viewModel.items.map { model in
//                let adapter = FontFontFileDataPresentationAdapter<WeakRefVirtualProxy<FontCellController>, UIFont>(
//                    fontFileDataLoader: fontFileLoader,
//                    model: model
//                )
//                let view = FontFontFileCellController(delegate: adapter)
//                adapter.presenter = FontFontFilePresenter(view: WeakRefVirtualProxy(view), fontFileTransformer: UIFontFile.init(data:))
//                return view
//            }
//        )
    }
}

private extension UIFont {
    static func make(data: Data, size _: CGFloat) -> UIFont? {
        guard
            let dataProvider = CGDataProvider(data: data as CFData),
            let cgFont = CGFont(dataProvider)
        else { return nil }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            return nil
        } else {
            guard let fontName = cgFont.postScriptName else {
                return nil
            }
            return UIFont(name: String(fontName), size: 30)
        }
    }
}
