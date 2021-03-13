import Foundation
import LoadingSystem

public protocol FontFileView: UniversalView where Union == FontFileViewModel<F> {
    associatedtype F
}



public final class FontFilePresenter<View: FontFileView, F>:
    UniversalPresenter<View, (Font, URL), FontFileViewModel<F>>
where View.F == F {
    
    
    public init(view: View, fontTransformer: @escaping (Data) -> F?) {
        let mapper = FontFileViewModelMapper()
        super.init(
            view: view,
            LoadingTransformer: mapper.loading(for: ),
            SuccessTransformer: {
                (input, data) in
                mapper.success(with: data, fontTransformer: fontTransformer, for: input)
            },
            FailureTransformer: {
                (input, error) in
                mapper.failure(input, with: error)
            })
    }
    
    
}

