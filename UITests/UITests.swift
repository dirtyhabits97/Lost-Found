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
        continueAfterFailure = false
        XCUIApplication().launch()
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
    
    func doLogOut() {
        let app = XCUIApplication()
        app.navigationBars["gonzalorehu"].buttons["userIcon"].tap()
        app.navigationBars["AudibleLike.Profile"].buttons["Cerrar Sesión"].tap()
    }
    
    func testHomeMenu() {
        doLogin()
        XCUIDevice.shared().orientation = .portrait
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cat1 = collectionViewsQuery.staticTexts["Mujeres entre 18 y 25"]
        let cat2 = collectionViewsQuery.staticTexts["Mayores de 60"]
        let cat3 = collectionViewsQuery.staticTexts["Menores de 18"]
        sleep(10)
        XCTAssert(cat1.exists)
        XCTAssert(cat2.exists)
        XCTAssert(cat3.exists)
        doLogOut()
    }
    
    func testProfile() {
        doLogin()
        let app = XCUIApplication()
        app.navigationBars["gonzalorehu"].buttons["userIcon"].tap()
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.staticTexts["72533800"].exists)
        XCTAssert(tablesQuery.staticTexts["Gonzalo"].exists)
        XCTAssert(tablesQuery.staticTexts["gonzalorehu"].exists)
        XCTAssert(tablesQuery.staticTexts["20"].exists)
        XCTAssert(tablesQuery.staticTexts["gonzalorh.97.31@gmail.com"].exists)
        app.navigationBars["AudibleLike.Profile"].buttons["Cerrar Sesión"].tap()
    }
    
    func testLogOut() {
        doLogin()
        doLogOut()
        let app = XCUIApplication()
        XCTAssert(app.buttons["Next"].exists)
    }
    
    func tapMoreButton() {
        doLogin()
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        let navBar = app.navigationBars["gonzalorehu"]
        navBar.buttons["Add"].tap()
        XCTAssert(app.buttons["Buscar Personas"].exists)
        XCTAssert(app.buttons["Presentar Denuncia"].exists)
        XCTAssert(app.buttons["Ver Mapa"].exists)
        XCTAssert(app.buttons["Ver Noticias"].exists)
    }
    
    func doFindDora() {
        tapMoreButton()
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.buttons["Buscar Personas"].tap()
        app.tables.staticTexts["Ortega, Dora"].tap()
    }
    
    func testClue() {
        doFindDora()
        let app = XCUIApplication()
        XCTAssert(app.staticTexts["Nombre: Ortega, Dora"].exists)
        XCTAssert(app.staticTexts["DNI: 98928392"].exists)
        XCTAssert(app.staticTexts["Edad: 22"].exists)
        app.navigationBars["Detalle"].buttons["Compose"].tap()
        XCTAssert(app.textFields["Asunto"].exists)
        app.navigationBars["Nueva Pista"].buttons["Cancelar"].tap()
        app.alerts["¿Está seguro que desea eliminar esta pista?"].buttons["Eliminar"].tap()
        app.navigationBars["Detalle"].buttons["Back"].tap()
        app.navigationBars["AudibleLike.SearchTableView"].buttons["Back"].tap()
        doLogOut()
    }
    
    func testReport() {
        tapMoreButton()
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.buttons["Presentar Denuncia"].tap()
        XCUIDevice.shared().orientation = .portrait
        XCTAssert(app.buttons["Enviar Reporte"].exists)
        app.buttons["Enviar Reporte"].tap()
        app.alerts["Aviso"].buttons["Ok"].tap()
        app.navigationBars["Denuncia"].buttons["Cancelar"].tap()
        app.alerts["¿Está seguro que desea no continuar la denuncia?"].buttons["Eliminar"].tap()
        sleep(2)
        doLogOut()
    }
}
