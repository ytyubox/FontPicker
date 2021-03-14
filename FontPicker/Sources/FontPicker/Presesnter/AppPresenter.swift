import LoadingSystem
import Foundation
public protocol IntroductionView: UniversalView where Union == IntroductionViewModel {
}
public final class AppPresenter<IntroView: IntroductionView>  {
    public init(introductionView: IntroView,
                  errorMessageFactory: @escaping (Error) -> IntroductionViewModel) {
        self.introductionView = introductionView
        self.errorMessageFactory = errorMessageFactory
    }
    
 
    public var introductionView: IntroView
    private let errorMessageFactory: (Error) -> IntroductionViewModel

    public static var introduction: String {
        return NSLocalizedString("APP_INTRODUCTION",
                                 tableName: "Font",
                                 bundle: .module,
                                 comment: "Introduction of the app")
    }
    public func didFinishLoading(with introduction: IntroductionViewModel) {
        introductionView.display(introduction)
    }

    public func didFinishLoading(with error: Error) {
        let message = errorMessageFactory(error)
        introductionView.display(message)
    }
}

public struct IntroductionViewModel {
    public init(content: String) {
        self.content = content
    }
    
    public let content:String
}
