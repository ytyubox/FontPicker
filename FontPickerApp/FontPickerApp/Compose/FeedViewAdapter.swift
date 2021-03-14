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

    init(controller: FontViewController,
         fontFileLoader: AnyCancellableLoader<Data>)
    {
        self.controller = controller
        self.fontFileLoader = fontFileLoader
    }

    func display(_ viewModel: FontViewModel) {
        controller?.display(
            viewModel.items.map{
                font in
                
                FontGroupController(
                    name: font.name,
                    demoText: font.name,
                    tableModel:
                        font.variants.map{
                            variant in
                            let adapt = FontFilePresentationAdapter<Proxy, UIFont>(
                                fontFileDataLoader: fontFileLoader,
                                model: variant,
                                url: variant.fileURL)
                            let view = FontCellController(delegate: adapt)
                            adapt.presenter = FontFilePresenter(
                                view: WeakRefVirtualProxy(view),
                                fontTransformer: UIFont.make)
                            return view
                        }
                )
            }
        )
    }
}

private extension UIFont {
    static func make(data: Data) -> UIFont? {
        make(data: data, size: 30)
    }
    static func make(data: Data, size: CGFloat) -> UIFont? {
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
            return UIFont(name: String(fontName), size: size)
        }
    }
}
