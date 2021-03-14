//
/* 
 *		Created by 游宗諭 in 2021/3/12
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation
extension FontFilePresenter {
    class FontFileViewModelMapper {
        
        typealias Output = FontFileViewModel<Input>.VariantViewModel
        private var cache:[URL: Input] = [:]
        func failure(_ model:Variant, with error:Error) -> Output {
            .init(font: nil, weight: model.name, shouldRetry: true, isLoading: false)
            
        }
        func loading(for  model:Variant) -> Output {
            .init(font: nil, weight: model.name, shouldRetry: false, isLoading: true)
        }
        
        func success(
            with data: Data,
            fontTransformer: (Data) throws -> Input?,
            for model:Variant) throws -> Output {
            let font = try fontTransformer(data)
            return Output(font: font, weight: model.name, shouldRetry: false, isLoading: false)
        }
        
        func successCaseFailure(for model: Variant, error: Error) -> Output {
            print(error)
            return Output(font: nil,
                   weight: model.name,
                   shouldRetry: true,
                   isLoading: false)
        }
    }
}
