import Foundation
import LoadingSystem

public protocol FontFileView: UniversalView where Union == FontFileViewModel<FONT>.VariantViewModel {
    associatedtype FONT
}



public final class FontFilePresenter<View: FontFileView, Input>:
UniversalPresenter<View, Variant, FontFileViewModel<Input>.VariantViewModel>
where View.FONT == Input {
    
    
    public init(view: View, fontTransformer: @escaping (Data) -> Input?) {
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

