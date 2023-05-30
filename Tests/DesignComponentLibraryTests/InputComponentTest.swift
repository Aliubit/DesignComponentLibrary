import XCTest
@testable import DesignComponentLibrary

final class InputComponentTest: XCTestCase {

    func testInputComponent() throws {
        /// if the test succeeds the component has no issues/errors
        _ = InputComponent(text: .constant(""), label: "", validationState: .constant(.none), onFinishEditing: {})
    }

    func testInvalidPasswordValidation() throws {
        // Given
        let passwordText = "123456"

        // When
        let validator = InputComponent.PasswordFieldValidator(text: passwordText, minCount: 8, maxCount: 8)

        // Then
        XCTAssertEqual(validator.validationState, .error)
    }

    func testValidPasswordValidation() throws {
        // Given
        let passwordText = "12345678"

        // When
        let validator = InputComponent.PasswordFieldValidator(text: passwordText, minCount: 8, maxCount: 8)

        // Then
        XCTAssertEqual(validator.validationState, .success)
    }
}
