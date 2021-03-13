

import CoreData

@objc(ManagedFont)
class ManagedFont: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var subsets: String
    @NSManaged var variants: NSOrderedSet
    @NSManaged var cache: ManagedCache
}

extension ManagedFont {
    static func first(with name: String, in context: NSManagedObjectContext) throws -> ManagedFont? {
        let request = NSFetchRequest<ManagedFont>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFont.name), name])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    static func fonts(from localFont: [LocalFont], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFont.map { local in
            let managed = ManagedFont(context: context)
            managed.name = local.name
            managed.category = local.category
            managed.subsets = local.subsets.joined(separator: "\t")
            managed.variants = ManagedVariant.variants(from: local.variants, in: context)
            return managed
        })
    }

    var localVariants: [LocalFont.LocalVariant] {
        return variants.compactMap { ($0 as? ManagedVariant)?.local }
    }

    var local: LocalFont {
        return LocalFont(name: name, variants: localVariants, subsets: subsets.components(separatedBy: "\t"), category: category)
    }
}
