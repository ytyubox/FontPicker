import Foundation
import LoadingSystem

public protocol FontFileView: UniversalView where Union == FontFileViewModel<FONT>.VariantViewModel {
    associatedtype FONT
}



public final class FontFilePresenter<View: FontFileView, Input>:
UniversalPresenter<View, Variant, FontFileViewModel<Input>.VariantViewModel>
where View.FONT == Input {
    
    
    public init(view: View, fontTransformer: @escaping (Data) throws -> Input?) {
        let mapper = FontFileViewModelMapper(variantName: Self.nameOfVariant)
        super.init(
            view: view,
            LoadingTransformer: mapper.loading(for: ),
            SuccessTransformer: {
                (input, data) in
                try mapper.success(with: data, fontTransformer: fontTransformer, for: input)
            },
            successCaseFailureTransformer: {
                (input, error) in
                mapper.successCaseFailure(for: input, error: error)
            }
            ,
            FailureTransformer: {
                (input, error) in
                mapper.failure(input, with: error)
            })
    }
    
    public static func nameOfVariant(_ variant: Variant) -> String {
        return NSLocalizedString("KEY_\(variant.name)",
                                 tableName: "Font",
                                 bundle: .module,
                                 comment: "name for the Variant")
    }
}

