import XCTest

class SigninEmailEntryUITests: XCTestCase {
    var app: XCUIApplication!
    var backButton: XCUIElement!
    var enterEmailLabel: XCUIElement!
    var emailLabel: XCUIElement!
    var emailTextField: XCUIElement!
    var clearButton: XCUIElement!
    var emailErrorLabel: XCUIElement!
    var nextButton: XCUIElement!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        backButton = app.navigationBars.buttons["signin_backButton"]
        enterEmailLabel = app.staticTexts["signin_enterEmailLabel"]
        emailLabel = app.staticTexts["signin_emailLabel"]
        emailTextField = app.textFields["signin_emailTextField"]
        clearButton = app.buttons["signin_clearButton"]
        emailErrorLabel = app.staticTexts["signin_emailErrorLabel"]
        nextButton = app.buttons["signin_nextButton"]
    }
    
    override func tearDown() {
        app = nil
        backButton = nil
        enterEmailLabel = nil
        emailLabel = nil
        emailTextField = nil
        clearButton = nil
        emailErrorLabel = nil
        nextButton = nil
        super.tearDown()
    }
    
    func test_초기_UI_존재_여부() {
        let coinMonLoginButton = app.buttons["coinMonLoginButton"]
        XCTAssertTrue(coinMonLoginButton.exists, "coinMonLoginButton does not exist")
        coinMonLoginButton.tap()
        
        XCTAssertTrue(backButton.exists)
        XCTAssertTrue(enterEmailLabel.exists)
        XCTAssertTrue(emailLabel.exists)
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(nextButton.exists)
    }
    
    func test_유효한_이메일_입력() {
        let coinMonLoginButton = app.buttons["coinMonLoginButton"]
        XCTAssertTrue(coinMonLoginButton.exists, "coinMonLoginButton does not exist")
        coinMonLoginButton.tap()
        emailTextField.tap()
        emailTextField.typeText("test@gmail.com")
        
        XCTAssertTrue(nextButton.isEnabled)
        XCTAssertTrue(clearButton.exists)
        
        nextButton.tap()
        sleep(1)
        nextButton.tap()
    }
    
    func test_존재하지_않는_이메일_입력() {
        let coinMonLoginButton = app.buttons["coinMonLoginButton"]
        XCTAssertTrue(coinMonLoginButton.exists, "coinMonLoginButton does not exist")
        coinMonLoginButton.tap()
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        XCTAssertTrue(nextButton.isEnabled)
        XCTAssertTrue(clearButton.exists)
        
        nextButton.tap()
        sleep(1)
        nextButton.tap()
        
        XCTAssertTrue(app.alerts["NoRegisteredEmailErrorAlertController"].exists)
        XCTAssertTrue(app.alerts["NoRegisteredEmailErrorAlertController"].buttons["NoRegisteredEmailErrorAlertControllerOKButton"].exists)
        
        app.alerts["NoRegisteredEmailErrorAlertController"].buttons["NoRegisteredEmailErrorAlertControllerOKButton"].tap()
    }
    
    func test_유효하지_않는_이메일_입력() {
        let coinMonLoginButton = app.buttons["coinMonLoginButton"]
        XCTAssertTrue(coinMonLoginButton.exists, "coinMonLoginButton does not exist")
        coinMonLoginButton.tap()
        emailTextField.tap()
        emailTextField.typeText("test@example")
        
        XCTAssertTrue(emailErrorLabel.exists)
        XCTAssertFalse(nextButton.isEnabled)
        XCTAssertTrue(clearButton.exists)
        clearButton.tap()
        
        XCTAssertEqual(emailTextField.value as? String, emailTextField.placeholderValue)
    }
}
