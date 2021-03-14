import Foundation
public final class AppPresenter  {
 
   

    public static var introduction: String {
        return NSLocalizedString("APP_INTRODUCTION",
                                 tableName: "Font",
                                 bundle: .module,
                                 comment: "Introduction of the app")
    }

}
