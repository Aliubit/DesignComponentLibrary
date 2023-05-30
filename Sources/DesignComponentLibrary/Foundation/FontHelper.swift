import SwiftUI

/// Type used for load custom fonts in our package
public struct FontHelper {

   public let name: String

    /// private initializer which is responsible to load and register the custom fonts
   private init(named name: String) {
      self.name = name
      do {
         try registerFont(named: name)
      } catch {
         let reason = error.localizedDescription
         fatalError("Failed to register font: \(reason)")
      }
   }

   public static let bold = FontHelper(named: "noto-ikea-latin-bold")
   public static let regular = FontHelper(named: "noto-ikea-latin-regular")
}
