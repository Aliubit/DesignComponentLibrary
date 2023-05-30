import SwiftUI

/// Custom Button component which is used to show a SwiftUI Button
public struct CustomButton: View {

    /// Text to display inside button
    public let text: String

    /// Action for the button
    public let action: () -> Void

    /// Bolor of the button text
    public let textColor: Color

    /// Border color for the button
    public let borderColor: Color

    /// Public initializer to use this component
    ///
    /// - Parameter text: String which will be displayed inside button
    /// - Parameter textColor: To determine the color of the text displayed
    /// - Parameter borderColor: To determine the color of the border for the button
    /// - Parameter action: Closure to handle the button action
    public init(text: String,
                textColor: Color = Color.textAndIcon1,
                borderColor: Color = Color.textAndIcon1,
                action: @escaping () -> Void) {
        self.text = text
        self.textColor = textColor
        self.borderColor = borderColor
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(text)
                .font(.bold.medium)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: Dimensions.Size.CustomButton.height)
        .background(border)
        .accessibility(label: Text("\(text) Button"))
    }
}
