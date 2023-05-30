import SwiftUI

/// Extension of SwiftUI Font  which encapsulates all the custom fonts used within the library
public extension Font {
    
    struct CustomFont {

        /// Returns a fixed-size font of the specified style.
        static func fixed(_ style: FontHelper, size: CGFloat) -> Font {
            return Font.custom(style.name, fixedSize: size)
        }
    }

    /// Type regular representing the custom font noto-ikea-latin-regular
    enum regular {
        static let small : Font = CustomFont.fixed(.regular, size: 12)
        static let medium : Font = CustomFont.fixed(.regular, size: 14)
        static let large : Font = CustomFont.fixed(.regular, size: 16)
    }

    /// Type regular representing the custom font noto-ikea-latin-bold
    enum bold {
        static let medium : Font = CustomFont.fixed(.bold, size: 14)
    }
}

/// Extension of UIKit Font  which encapsulates all the custom fonts used within the library
public extension UIFont {
    
    struct CustomFont {

        /// Returns a fixed-size font of the specified style.
        static func fixed(_ style: FontHelper, size: CGFloat) -> UIFont {
            return UIFont(name: style.name, size: size) ?? .systemFont(ofSize: size)
        }
    }

    /// Type regular representing the custom font noto-ikea-latin-regular
    enum regular {
        static let medium : UIFont = CustomFont.fixed(.regular, size: 14)
    }

}
