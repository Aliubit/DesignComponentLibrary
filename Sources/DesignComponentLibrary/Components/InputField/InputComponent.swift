import SwiftUI

/// A component which displays an input field.
/// The input field consists of a label, InputComponent, icon and description
/// The example uses of this component are for e.g in the login screen for username/password fields
public struct InputComponent: View {

    /// The type of the keyboard
    /// possible values alphabetic, numberpad, decimalpad etc
    public let keyboardType: UIKeyboardType

    /// the binding text which user will write inside the InputComponent
    public let text: Binding<String>

    /// Color of the text to be used inside the InputComponent
    public let textColor: Color

    /// Color of the label text
    public let labelColor: Color

    /// Variable to determine if the InputComponent will display it's input characters
    /// Possible usage for Password fields : set to false
    /// default is true
    public let isSecure: Bool

    /// String to display as a label on top of the InputComponent
    /// Will be used as a title for the InputComponent
    public let label: String

    /// Binding variable validationState will determing the state of the InputComponent
    /// Possible inputs are none, error and success
    public let validationState: Binding<InputComponentValidation>?

    /// The optional description text to show below the InputComponent
    /// This can be used to show validation messages to the user
    public var descriptionText: Binding<String>?

    /// The maximum character limit of the InputComponent
    public let maxCharLimit: Int

    /// The minimum character limit of the InputComponent
    public let minCharLimit: Int

    /// The icon to display at the trailing end of the InputComponent
    /// Possible use case is to show a icon button to toggle secure and normal InputComponent
    public let trailingIcon: TrailingIcon?

    /// Closure to be called when the InputComponent has finished it's editing
    /// Possible use cases are to validate the InputComponent when it is called
    public let onFinishEditing: (() -> Void)

    /// State variable used to determing if the InputComponent is in editing mode
    /// This is used to show distinct border while field is in editing mode
    @State var isEditing: Bool = false

    /// Public initializer to access this component
    /// - Parameter keyboardType: type of the keyboard to be used by the InputComponent. Default is alphabetic
    /// - Parameter text: InputComponent's text
    /// - Parameter textColor: Color of the text. Default is textAndIcon1
    /// - Parameter isSecure: Boolean to determing if the InputComponent should show it's characters. Default is false
    /// - Parameter label: To display title of the InputComponent
    /// - Parameter labelColor: Color of the label. Default is textAndIcon2
    /// - Parameter validationState: An optional type used to validate the InputComponent
    /// - Parameter descriptionText: An optional text to display at the bottom of the InputComponent
    /// - Parameter maxCharLimit: Maximum number of characters to be enterted inside the InputComponent
    /// Default is 100
    /// - Parameter minCharLimit: Minimum number of characters to be enterted inside the InputComponent
    /// Default is 0
    /// - Parameter trailingIcon: An optional type which encalsulates an Icon and an button to show at the trailing end of the InputComponent
    /// - Parameter onFinishEditing: A closure which will be triggered when the InputComponent finishes it's editing
    public init(keyboardType: UIKeyboardType = .alphabet,
                text: Binding<String>,
                textColor: Color = .textAndIcon1,
                isSecure: Bool = false,
                label: String,
                labelColor: Color = .textAndIcon2,
                validationState: Binding<InputComponentValidation>?,
                descriptionText: Binding<String>? = nil,
                maxCharLimit: Int = 100,
                minCharLimit: Int = 0,
                trailingIcon: TrailingIcon? = nil,
                onFinishEditing: @escaping () -> Void) {
        self.keyboardType = keyboardType
        self.text = text
        self.textColor = textColor
        self.isSecure = isSecure
        self.label = label
        self.labelColor = labelColor
        self.validationState = validationState
        self.descriptionText = descriptionText
        self.maxCharLimit = maxCharLimit
        self.minCharLimit = minCharLimit
        self.trailingIcon = trailingIcon
        self.onFinishEditing = onFinishEditing
    }

    public var body: some View {
        VStack(alignment: .leading,
               spacing: Dimensions.Spacing.InputComponent.innerSpacing) {
            labelView
            inputView
            if descriptionText != nil {
                descriptionView
            }
        }
        /// to ignore the individual child component accessibility
        .accessibilityElement(children: .ignore)
        /// customized accessibility label
        .accessibility(label: accessibilityText)
        .accessibilityValue(Text(text.wrappedValue))
    }

    /// A view used as a title for the component
    var labelView: some View {
        Text(label)
            .font(.regular.medium)
            .foregroundColor(labelColor)
            .tracking(Dimensions.Spacing.TextComponent.standardLetterSpacing)
    }

    /// View used for the input
    var inputView: some View {
        HStack(alignment: .center, spacing: Dimensions.Spacing.systemFive) {
            textField
            if trailingIcon != nil {
                trailingIconButton
                    .padding(.trailing, Dimensions.Spacing.systemFive)
            }
        }
        .padding(padding)
        .background(border)
    }

    /// TextField used as an input component
    var textField: some View {
        /// UITextField Representable used instead of SwiftUI SecureField because of it's limitations like focus and not having editing and onCommit closures
        CustomTextField(text: text.max(maxCharLimit),
                        keyboardType: keyboardType,
                        isSecure: isSecure,
                        onEditingChanged: onToggleEditing,
                        onFinishEditing: onFinishEditing)
        .font(.regular.small)
        .foregroundColor(textColor)
        .frame(height: Dimensions.Size.InputComponent.textFieldHeight)
    }

    /// Trailing icon and button
    @ViewBuilder
    var trailingIconButton: some View {
        if let trailingIcon {
            Button(action: trailingIcon.action) {
                trailingIcon.icon
            }
        }
    }

    /// View to show the text at the bottom of the InputComponent
    var descriptionView: some View {
        return HStack(alignment: .center, spacing: Dimensions.Spacing.systemTen){
            if let descriptionIcon {
                descriptionIcon
            }
            if let descriptionText {
                Text(descriptionText.wrappedValue)
                    .font(.regular.small)
                    .foregroundColor(descriptionColor)
            }
            Spacer()
            if let charCountText {
                Text(charCountText)
                    .foregroundColor(Color.textAndIcon3)
                    .font(.regular.small)
            }
        }
    }

    /// An icon to show with the descriptionText
    var descriptionIcon: Image? {
        switch validationState?.wrappedValue ?? .none {
        case .error:
            return .warning
        case .success:
            return .success
        default:
            return nil
        }
    }

    /// String with format "Minimum/Maximum" characters to show only if the descriptionText is available and validaiton state is none
    var charCountText: String? {
        switch validationState?.wrappedValue ?? .none {
        case .none:
            return "\(text.wrappedValue.count)/\(maxCharLimit)"
        default:
            return nil
        }
    }
}
