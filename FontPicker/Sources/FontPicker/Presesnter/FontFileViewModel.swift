
import Foundation
public struct FontFileViewModel<F> {
    public let name:String
    public let fontDemoText:String
    public let variants: [VariantViewModel]
    public let subsets:[String]
    public let category:String
    public let shouldRetry:Bool
    
    public struct VariantViewModel {
        public init(font: F?, weight: String, url: URL) {
            self.font = font
            self.weight = weight
            self.url = url
        }
        
        public var font: F?
        public let weight:String
        public let url:URL
    }
}



extension Variant {
//    func viewModel<F>(font: F?, url: URL) -> FontFileViewModel<F>.VariantViewModel {
//        
//        .init(font: url == fileURL
//                ? font
//                : nil,
//              weight: name,
//              url: fileURL)
//    }
    func viewModel<F>(font: F?) -> FontFileViewModel<F>.VariantViewModel {
        
        .init(font: font,
              weight: name,
              url: fileURL)
    }
}