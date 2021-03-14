//
/*
 *		Created by 游宗諭 in 2021/3/11
 *
 *		Using Swift 5.0
 *
 *		Running on macOS 11.2
 */

import CoreData
import FontPicker
import FontPickeriOS
import LoadingSystem
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var root:Root = {
        let adapter:AppFontStoreAdapter? = AppFontStoreAdapter()
        let null = NullStore()
        var root: Root = Container(
            httpClient: makeHTTPClient(),
            fontStore: (adapter?.toAnyStore() ?? null.toAnyStore()),
            fileStore: adapter ?? null
        )
        return root
    }()
    convenience init(root: Root) {
        self.init()
        self.root = root
    }

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = root.makeRootViewController()
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_: UIScene) {
        root.validateCache()
    }
}

func makeHTTPClient() -> HTTPClient {
    
    URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
}
