import XCTest
@testable import DesignComponentLibrary

final class ButtonComponentTest: XCTestCase {

    func testCustomButtonComponent() throws {
        /// if the test succeeds the component has no issues/errors
        _ = CustomButton(text: "", action: {})
    }
}
