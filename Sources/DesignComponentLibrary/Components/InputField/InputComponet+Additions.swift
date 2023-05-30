import SwiftUI

/// An extension of InputComponent which defines the ValidationState
extension InputComponent {
    /// A type which is used to determine the possible states of the InputComponent
    public enum InputComponentValidation {
        case none
        case error
        case success
    }
}

/// An extension of InputComponent which defines the UI properties
extension InputComponent {

    /// Shape of the border around InputComponent
    var border: some View {
        RoundedRectangle(cornerRadius: Dimensions.Size.InputComponent.cornerRadius)
            .strokeBorder(
                borderColor,
                lineWidth: borderWidth
            )
    }

    /// Dynamic color of the border to be calculated on two basis
    /// it's validationState and if the field is in editing mode
    var borderColor: Color {
        switch validationState?.wrappedValue ?? .none {
        case .none: return isEditing ? Color.interactiveEmphasisedBgDefault : Color.neutral5
        case .error: return Color.semanticNegative
        case .success: return Color.semanticPositive
        }
    }

    /// The width of the border
    var borderWidth: CGFloat {
        if isEditing {
            return Dimensions.Size.InputComponent.thickBorder
        } else {
            return Dimensions.Size.InputComponent.normalBorder
        }
    }

    /// The padding inside the InputComponent
    var padding: EdgeInsets {
        return Dimensions.Spacing.InputComponent.standardPadding
    }

    /// The color of the descriptionText
    /// Depends on the validation state
    var descriptionColor: Color {
        switch validationState?.wrappedValue ?? .none {
        case .none: return Color.textAndIcon3
        case .error: return Color.semanticNegative
        case .success: return Color.semanticPositive
        }
    }
}

/// An extenion which defines function used to handle change in editing of input component
extension InputComponent {
    var onToggleEditing: (Bool) -> Void {
        {
            self.isEditing = $0
        }
    }
}

/// An extension which defines the UIRepresentable TextField
extension InputComponent {
    struct CustomTextField: UIViewRepresentable {

        /// Binding text value
        @Binding var text: String

        /// The type of the keyboard to be used by the TextField
        let keyboardType: UIKeyboardType

        /// var to determine if the TextField is secure
        var isSecure: Bool

        /// Closue to handle change in editing
        var onEditingChanged: ((Bool) -> Void)

        /// Closure to handle the state when the editing is finished
        var onFinishEditing: (() -> Void)

        func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
            let textField = UITextField(frame: .zero)
            /// The numberPad and decimalPad don't show a done button
            /// Added a custom done button
            if case .numberPad = keyboardType {
                addDoneButtonOnNumpad(textField: textField,
                                      coordinator: context.coordinator)
            }
            textField.isUserInteractionEnabled = true
            textField.delegate = context.coordinator
            textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return textField
        }

        func makeCoordinator() -> CustomTextField.Coordinator {
            return Coordinator(
                text: $text,
                isSecure: isSecure,
                onEditingChanged: onEditingChanged,
                onFinishEditing: onFinishEditing
            )
        }

        func updateUIView(_ textField: UITextField, context: Context) {
            textField.text = text
            textField.isSecureTextEntry = isSecure
            textField.keyboardType = keyboardType
            textField.returnKeyType = .done
            textField.font = .regular.medium
            textField.autocorrectionType = .no
        }

        /// Function used to add a Done button on a numberPad type keyboard
        /// So that the user can finish editing easily
        func addDoneButtonOnNumpad(textField: UITextField,
                                   coordinator: Coordinator) {

            let keypadToolbar: UIToolbar = UIToolbar()

            /// add a done button to the numberpad
            keypadToolbar.items=[
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: coordinator, action: #selector(Coordinator.doneAction))
            ]
            keypadToolbar.sizeToFit()
            /// add a toolbar with a done button above the number pad
            textField.inputAccessoryView = keypadToolbar
        }

        class Coordinator: NSObject, UITextFieldDelegate {
            @Binding var text: String
            var isSecure: Bool
            var onEditingChanged: ((Bool) -> Void)
            var onFinishEditing: (() -> Void)

            init(
                text: Binding<String>,
                isSecure: Bool,
                onEditingChanged: @escaping ((Bool) -> Void) = { _ in },
                onFinishEditing: @escaping (() -> Void) = { }
            ) {
                _text = text
                self.isSecure = isSecure
                self.onEditingChanged = onEditingChanged
                self.onFinishEditing = onFinishEditing
            }

            /// Selector which will be triggered when user will press the custom done button on numberpad keyboard
            @objc func doneAction() {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                onFinishEditing()
            }

            func textFieldDidChangeSelection(_ textField: UITextField) {
                Task { @MainActor in
                    text = textField.text ?? ""
                }
            }

            func textFieldDidBeginEditing(_ textField: UITextField) {
                Task { @MainActor in
                    self.onEditingChanged(true)
                }
            }

            func textFieldDidEndEditing(_ textField: UITextField) {
                Task { @MainActor in
                    self.onEditingChanged(false)
                }
            }

            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                self.onFinishEditing()
                textField.resignFirstResponder()
                return true
            }
        }
    }
}

/// An extension which defines a Custom type TrailingIcon
extension InputComponent {
    /// A type used to display an IconButton
    public struct TrailingIcon {
        public let icon: Image
        public let accessibilityName: String
        public let action: (() -> Void)

        /// Public initializer for TrailingIcon component to be used inside InputComponent
        /// - Parameter icon: The image to be displayed
        /// - Parameter accessibilityName: the provided accessibility name for the image
        /// - Parameter action: closure action for the button
        public init(icon: Image,
                    accessibilityName: String,
                    action: @escaping () -> Void) {
            self.icon = icon
            self.accessibilityName = accessibilityName
            self.action = action
        }
    }
}

/// An extension of Binding to limit the max characters of a string
extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

/// An extension which defines a validator
extension InputComponent {

    /// A validator to validate the password
    public struct PasswordFieldValidator {
        let maxCount: Int
        let minCount: Int
        let text: String

        public var validationState: InputComponent.InputComponentValidation {
            let range = (minCount
                         ...
                         maxCount)
            if range.contains(text.count) {
                return .success
            } else {
                return .error
            }
        }

        public var displayMessage: String {
            switch validationState {
            case .none:
                return "Only numeric input allowed"
            case .error:
                return "Please only enter up to 8 characters"
            case .success:
                return "Success"
            }
        }

        /// Public initializer for PasswordValidator
        /// - Parameter text: representing the password
        /// - Parameter minCount: representing the minium number of characters the password should contain
        /// - Parameter maxCount: representing the maximum number of characters the password should contain
        public init(text: String,
                    minCount: Int = 8,
                    maxCount: Int = 8) {
            self.text = text
            self.minCount = minCount
            self.maxCount = maxCount
        }
    }
}

/// An extension which defines the accessibility text for the InputComponent
extension InputComponent {
    var accessibilityText: Text {
        var type: String {
            isSecure ? "Secure text field" : "text field"
        }

        var labelText: String {
            "Label: \(label)"
        }

        var trailingIconText: String {
            if let trailingIcon {
                return "Icon: \(trailingIcon.accessibilityName)"
            } else {
                return ""
            }
        }

        var descText: String {
            if let descriptionText {
                var validationDesc: String {
                    switch validationState?.wrappedValue ?? .none {
                    case .none: return "none"
                    case .error: return "error"
                    case .success: return "success"
                    }
                }
                return "Description: \(descriptionText.wrappedValue) :  Validation State: \(validationDesc)"
            } else {
                return ""
            }
        }

        let joinedString = [type, labelText, trailingIconText, descText].joined(separator: ": ")
        return Text(joinedString)
    }
}
