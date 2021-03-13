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
        private var cache:[URL: F] = [:]
        func failure(_ pair: (model:Font,url: URL), with error:Error) -> FontFileViewModel<F> {
            
            FontFileViewModel(
                name: pair.model.name,
                fontDemoText: "Demo",
                variants: pair.model.variants.map({$0.viewModel(font: nil)}),
                subsets: pair.model.subsets,
                category: pair.model.category,
                shouldRetry: true
            )
            
        }
        func loading(for  pair: (model:Font,url: URL)) -> FontFileViewModel<F> {
            
            return FontFileViewModel(
                name: pair.model.name,
                fontDemoText: "Demo",
                variants: pair.model.variants.map({$0.viewModel(font: nil)}),
                subsets: pair.model.subsets,
                category: pair.model.category,
                shouldRetry: false
            )
        }
        
        func success(
            with data: Data,
            fontTransformer: (Data) -> F?,
            for pair: (model:Font,url: URL)) -> FontFileViewModel<F> {
            let font = fontTransformer(data)
            let variants = pair.model.variants.map {
                variant -> FontFileViewModel<F>.VariantViewModel in
                let _font =
                    pair.url == variant.fileURL
                ? font
                    :cache[variant.fileURL]
                
                return variant.viewModel(font: _font)
            }
            
            cache[pair.url] = font
            dump(variants.map(\.font))
            return FontFileViewModel(
                name: pair.model.name,
                fontDemoText: "Demo",
                variants: variants,
                subsets: pair.model.subsets,
                category: pair.model.category,
                shouldRetry: false
            )
        }
    }
}
