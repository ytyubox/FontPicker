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
import Foundation
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

class FontLoaderAdaptIntroction: FontViewControllerDelegate {
    internal init(decoratee: FontViewControllerDelegate,
                  presenter: AppPresenter<IntroduceSectionController>) {
        self.decoratee = decoratee
        self.presenter = presenter
    }
    
    
    var decoratee: FontViewControllerDelegate
    var presenter: AppPresenter<IntroduceSectionController>
    
    func didRequestRefresh() {
        decoratee.didRequestRefresh()
        presenter.didFinishLoading(with: IntroductionViewModel(content: AppPresenter<IntroduceSectionController>.introduction))
    }
}

extension FontViewControllerDelegate {
    func adaptIntroction(view: IntroduceSectionController) -> FontViewControllerDelegate{
        FontLoaderAdaptIntroction(decoratee: self, presenter: .init(introductionView: view, errorMessageFactory: { (error) -> IntroductionViewModel in
            IntroductionViewModel(content: error.localizedDescription)
        }))
    }
}

