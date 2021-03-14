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

class FontFontFileDataPresentationAdapter<View, FONT>:
    FontCellControllerDelegate
    where
    View: FontFileView, View.FONT == FONT
{
    typealias INPUT = PairAdapter
    let fontFileDataLoader: AnyCancellableLoader<Data>
    let model: INPUT

    init(fontFileDataLoader: AnyCancellableLoader<Data>,
         model: INPUT)
    {
        self.fontFileDataLoader = fontFileDataLoader
        self.model = model
    }

    var presenter: FontFilePresenter<View, FONT>!

    private var task: CancellabelTask?

    func requestLoad() {
        presenter.didStartLoadingData(for: model.pair)
        let model = self.model
        task = fontFileDataLoader
            .load(from: model.url) {
                [weak self] result in
                self?.didLoadFontFileData(result)
            }
    }

    private func didLoadFontFileData(_ result: Result<Data, Error>) {
        switch result {
        case let .success(data):
            presenter.didFinishLoadingData(with: data, for: model.pair)
        case let .failure(error):
            presenter.didFinishLoadingData(with: error, for: model.pair)
        }
    }

    func cancelLoad() {
        task?.cancel()
        task = nil
    }

    private struct FontFileConvertFailure: Error {}
}

struct PairAdapter {
    let model: Variant
    let url: URL
    var pair: (Variant, URL) {
        (model, url)
    }
}
