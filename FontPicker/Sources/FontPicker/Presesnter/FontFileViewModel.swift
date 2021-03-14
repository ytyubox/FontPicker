
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
                    shouldRetry: Bool,
                    isLoading:Bool
        ) {
            self.font = font
            self.weight = weight
            self.shouldRetry = shouldRetry
            self.isLoading = isLoading
        }

        public let shouldRetry: Bool
        public var font: F?
        public let weight: String
        public let isLoading: Bool
    }
}

extension Variant {

    func viewModel<F>(font: F?, shouldRetry: Bool) -> FontFileViewModel<F>.VariantViewModel {
        .init(font: font,
              weight: name,
              shouldRetry: shouldRetry, isLoading: false)
    }
}
