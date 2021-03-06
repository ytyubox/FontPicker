//
/*
 *		Created by 游宗諭 in 2021/3/12
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import FontPicker
import LoadingSystem
import UIKit

class Container {
    private let httpClient: HTTPClient
    private let fontStore: AnyStore<LocalFont>
    private let fileStore: DataStore
    
    
    internal init(httpClient: HTTPClient,
                  fontStore: AnyStore<LocalFont>,
                  fileStore: DataStore) {
        self.httpClient = httpClient
        self.fontStore = fontStore
        self.fileStore = fileStore
    }
    
    

    private lazy var localFontStore: AnyStore<LocalFont> =
        AnyStore(fontStore)
    private lazy var fontFileDataStore: DataStore = fileStore

    private lazy var remoteFontLoader: AnyLoader<[Font]> = {
        RemoteFontLoader(
            url: URL(string: "https://www.googleapis.com/webfonts/v1/webfonts?key=\(APIKEY)")!,
            client: httpClient
        ).toAnyLoader()
    }()

    private lazy var localFontLoader =
        LocalFontLoader(store: localFontStore, currentDate: Date.init)

    private lazy var remoteFontFileLoader =
        RemoteFontFileLoader(client: httpClient
                                .log(with: PrintLogger())
        )

    private lazy var localFontFileLoader =
        LocalFontFileLoader(store: fontFileDataStore)

  
}

extension Container: Root {
    func makeRootViewController() -> UIViewController {
        let primaryLoader = FontLoaderCacheDecorator(
            decoratee: remoteFontLoader,
            cache: localFontLoader
        ).toAnyLoader()
        let loader = FontLoaderWithFallbackComposite(
            primary: primaryLoader,
            fallback: localFontLoader.toAnyLoader()
        )

        let fontFileLoader = FontFileDataLoaderWithFallbackComposite(
            primary: localFontFileLoader.toAnyCancellableLoader(),
            fallback: FontFileDataLoaderCacheDecorator(
                decoratee: remoteFontFileLoader.toAnyCancellableLoader(),
                cache: localFontFileLoader
            ).toAnyCancellableLoader()
        )
        let vc = FontUIComposer.fontComposedWith(
            fontLoader: loader.toAnyLoader(),
            fontFileLoader: fontFileLoader.toAnyCancellableLoader()
        )
        return UINavigationController(rootViewController: vc)
    }

    func validateCache() {
        localFontLoader.validateCache { _ in }
    }
}

extension LocalFontLoader: FontCache {}
extension LocalFontFileLoader: FontFileLoader {}
extension RemoteFontFileLoader: FontFileLoader {}

private let APIKEY_PLISTKEY = "GOOGLEAPIKEY"
private let APIKEY: String = {
    let bundle = Bundle.main
    let dictory = bundle.infoDictionary
    let valueFromKey = dictory?[APIKEY_PLISTKEY]
    let value = valueFromKey
    let key = value as! String
    assert(!key.isEmpty, "APIKEY did not set, Please set in secrets.xcconfig")
    return key
}()


