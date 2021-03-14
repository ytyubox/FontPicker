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

class FontFilePresentationAdapter<View, FONT>:
    FontCellControllerDelegate
    where
    View: FontFileView, View.FONT == FONT
{
    typealias INPUT = Variant
    let fontFileDataLoader: AnyCancellableLoader<Data>
    let model: INPUT
    let url:URL

    init(fontFileDataLoader: AnyCancellableLoader<Data>,
         model: INPUT,
         url: URL
    )
    {
        self.fontFileDataLoader = fontFileDataLoader
        self.model = model
        self.url = url
    }

    var presenter: FontFilePresenter<View, FONT>!

    private var task: CancellabelTask?

    func requestLoad() {
        presenter.didStartLoadingData(for: model)
        task = fontFileDataLoader
            .load(from: url) {
                [weak self] result in
                self?.didLoadFontFileData(result)
            }
    }

    private func didLoadFontFileData(_ result: Result<Data, Error>) {
        switch result {
        case let .success(data):
            presenter.didFinishLoadingData(with: data, for: model)
        case let .failure(error):
            presenter.didFinishLoadingData(with: error, for: model)
        }
    }

    func cancelLoad() {
        task?.cancel()
        task = nil
    }

    private struct FontFileConvertFailure: Error {}
}

