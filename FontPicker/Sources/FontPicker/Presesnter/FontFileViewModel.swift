
import Foundation
public struct FontFileViewModel<F> {
    public init(name: String, fontDemoText: String, variants: [FontFileViewModel<F>.VariantViewModel], subsets: [String], category: String) {
        self.name = name
        self.fontDemoText = fontDemoText
        self.variants = variants
        self.subsets = subsets
        self.category = category
    }

    public let name: String
    public let fontDemoText: String
    public let variants: [VariantViewModel]
    public let subsets: [String]
    public let category: String

    public struct VariantViewModel {
        public init(font: F?,
                    weight: String,
//                    url: URL,
                    shouldRetry: Bool) {
            self.font = font
            self.weight = weight
//            self.url = url
            self.shouldRetry = shouldRetry
        }

        public let shouldRetry: Bool
        public var font: F?
        public let weight: String
//        public let url: URL
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
    func viewModel<F>(font: F?, shouldRetry: Bool) -> FontFileViewModel<F>.VariantViewModel {
        .init(font: font,
              weight: name,
              shouldRetry: shouldRetry)
    }
}
