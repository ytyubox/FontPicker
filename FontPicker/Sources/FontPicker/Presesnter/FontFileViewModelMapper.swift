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
        func failure(_ pair: (model:Variant,url: URL), with error:Error) -> Output {
            .init(font: nil, weight: pair.model.name, url: pair.url, shouldRetry: true)
//            FontFileViewModel(
//                name: pair.model.name,
//                fontDemoText: "Demo",
//                variants: pair.model.variants.map({$0.viewModel(font: nil, shouldRetry: true)}),
//                subsets: pair.model.subsets,
//                category: pair.model.category
//            )
            
        }
        func loading(for  pair: (model:Variant,url: URL)) -> Output {
            .init(font: nil, weight: pair.model.name, url: pair.url, shouldRetry: false)
        }
        
        func success(
            with data: Data,
            fontTransformer: (Data) -> Input?,
            for pair: (model:Variant,url: URL)) -> Output {
            let font = fontTransformer(data)
            return Output(font: font, weight: pair.model.name, url: pair.model.fileURL, shouldRetry: false)
        }
    }
}
