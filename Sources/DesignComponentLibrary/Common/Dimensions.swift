import SwiftUI

/// Common type Dimensions which contains all the spacing and size constants user within the library
public enum Dimensions {

    /// Spacing type which encapsulates all the custom spacing
    public enum Spacing {

        /// Below are the component-independent spacing constants
        public static let systemTen: CGFloat = 10
        public static let systemFive: CGFloat = 5
        public static let systemTwentyFour: CGFloat = 25
        public static let systemThirtyThree: CGFloat = 33

        /// Type in which all the spacings/paddings related to Input Component are defined
        public enum InputComponent {
            static let innerSpacing: CGFloat = 5
            static let standardPadding = EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8)
        }

        /// Type in which all the spacings/paddings related to Text Component are defined
        public enum TextComponent {
            static let standardLetterSpacing = 0.5
        }
    }

    /// Size type which encapsulates all the custom Size used through the library
    public enum Size {

        /// Sizes used by input component are defined in below type
        public enum InputComponent {
            static let normalBorder: CGFloat = 1
            static let thickBorder: CGFloat = 2
            static let textFieldHeight: CGFloat = 26
            static let cornerRadius: CGFloat = 4
        }

        /// Sizes used by custom button component are defined in below type
        public enum CustomButton {
            static let height: CGFloat = 56
            static let normalBorder: CGFloat = 1
        }
    }
}
