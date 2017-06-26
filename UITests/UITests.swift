//
//  UITests.swift
//  UITests
//
//  Created by Gonzalo Reyes Huertas on 6/26/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func doLogin() {
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        app.buttons["Skip"].tap()
        
        let usuarioTextField = app.collectionViews.textFields["Usuario"]
        let passwordTextField = app.collectionViews.secureTextFields["Contraseña"]
        let loginButton = app.collectionViews.cells.children(matching: .button)["Log in"]
        usuarioTextField.tap()
        usuarioTextField.typeText("gonzalorehu")
        passwordTextField.tap()
        passwordTextField.typeText("abc")
        loginButton.tap()
    }
    
    func testProfile() {
        doLogin()
        let app = XCUIApplication()
        XCUIDevice.shared().orientation = .faceUp
        app.navigationBars["gonzalorehu"].buttons["userIcon"].tap()
        
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.staticTexts["72533800"].exists)
        XCTAssert(tablesQuery.staticTexts["Gonzalo"].exists)
        XCTAssert(tablesQuery.staticTexts["gonzalorehu"].exists)
        XCTAssert(tablesQuery.staticTexts["20"].exists)
        XCTAssert(tablesQuery.staticTexts["gonzalorh.97.31@gmail.com"].exists)
        
    }
    
}
