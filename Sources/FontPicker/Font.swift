import Foundation
public struct Font {
    let name:String
    let variants: [Variant]
    let subsets:String
    let category:String

}

struct Variant {
    let name: String
    let fileURL: URL
}
