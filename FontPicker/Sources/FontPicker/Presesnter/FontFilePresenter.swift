import Foundation
import LoadingSystem

public protocol FontFileView: UniversalView where Union == FontFileViewModel<F> {
    associatedtype F
}

public final class FontFilePresenter<View: FontFileView, F>:UniversalPresenter<View, Font, FontFileViewModel<F>> where View.F == F {
    
    
    public init(view: View, fontTransformer: @escaping (Data) -> F?) {
        super.init(
            view: view,
            LoadingTransformer: FontFileViewModelMapper.loading(for: ),
            SuccessTransformer: {
                (input, data) in
                FontFileViewModelMapper.success(with: data, fontTransformer: fontTransformer, for: input)
            },
            FailureTransformer: {
                (input, error) in
                FontFileViewModelMapper.failure(input, with: error)
            })
    }
}

