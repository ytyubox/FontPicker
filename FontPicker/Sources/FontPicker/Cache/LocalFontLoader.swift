//
/* 
 *		Created by 游宗諭 in 2021/3/13
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.2
 */


import Foundation

import LoadingSystem
public final class LocalFontLoader<AStore: Store>: LocalLoader<[Font], AStore> where AStore.Local == LocalFont {
    public convenience init(store: AStore, currentDate: @escaping () -> Date) {
        self.init(store: store, currentDate: currentDate) {
            cache in
            cache.item.toModels()
        }
    }
}
