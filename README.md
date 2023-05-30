# DesignComponentLibrary

A basic swift package which includes resuable iOS design components such as Input and Button

## How to use

### Swift Package Manager

the url for SPM is the same as the current repo "https://github.com/Aliubit/DesignComponentLibrary"

## Usage

import DesignComponentLibrary 

### InputComponent

call the public constructor for InputComponent

#### Example 1
Below is the example of a username field

        InputComponent(keyboardType: .default, text: $userName,
                       isSecure: false, label: "Username",
                       validationState: nil,
                       descriptionText: nil,
                       maxCharLimit: 100,
                       trailingIcon: nil,
                       onFinishEditing: {}) 

#### Example 2
Below is the example of a password field

        InputComponent(keyboardType: .numberPad, text: $password,
                       isSecure: isSecure, label: "Pin",
                       validationState: $passwordValidation,
                       descriptionText: $passwordDescriptionText,
                       maxCharLimit: 8,
                       trailingIcon: InputComponent.TrailingIcon(icon: isSecure ? .eye : .eyeSlash, accessibilityName: isSecure ? "Show pin" : "Hide pin", action: {}),
                       onFinishEditing: validatePassword)


### Button
Below is the example of a Login button

                CustomButton(text: "Login") {
                    // Action
                }

