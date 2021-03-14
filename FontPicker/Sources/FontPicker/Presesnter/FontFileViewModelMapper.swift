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
            .init(font: nil, weight: model.name, shouldRetry: true)
            
        }
        func loading(for  model:Variant) -> Output {
            .init(font: nil, weight: model.name, shouldRetry: false)
        }
        
        func success(
            with data: Data,
            fontTransformer: (Data) -> Input?,
            for model:Variant) -> Output {
            let font = fontTransformer(data)
            return Output(font: font, weight: model.name, shouldRetry: false)
        }
    }
}
