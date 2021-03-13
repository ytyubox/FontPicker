import Foundation
import LoadingSystem
public protocol FontView: ItemsView where Item == Font {}
public typealias FontLoadingView = LoadingView
public typealias FontErrorView = ErrorView


public final class FontPresenter<SuccessView: FontView>: Presenter<Font, SuccessView>  {
    
    private static var loadError: String {
        return NSLocalizedString("FONT_VIEW_CONNECTION_ERROR",
                                 tableName: "Font",
                                 bundle: .module,
                                 comment: "Error message displayed when we can't load the font from the server")
    }

    public convenience init(fontView: SuccessView, loadingView: FontLoadingView, errorView: FontErrorView) {
        self.init(itemsView: fontView,
                  loadingView: loadingView,
                  errorView: errorView,
                  errorMessageFactory: {
                    _ in
                    Self.loadError
                  }
        )
    }
   

    public static var title: String {
        return NSLocalizedString("FONT_VIEW_TITLE",
                                 tableName: "Font",
                                 bundle: .module,
                                 comment: "Title for the Font view")
    }

}
