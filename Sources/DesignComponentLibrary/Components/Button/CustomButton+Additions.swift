import SwiftUI

/// Extension for custom button component which contais the computed variables -
/// - border and borderWidth
extension CustomButton {
    var border: some View {
        RoundedRectangle(cornerRadius: Dimensions.Size.CustomButton.height / 2)
            .strokeBorder(
                borderColor,
                lineWidth: borderWidth
            )
    }

    var borderWidth: CGFloat {
        return Dimensions.Size.InputComponent.normalBorder
    }
}
