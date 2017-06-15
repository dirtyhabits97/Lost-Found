//
//  AudibleLikeTests.swift
//  AudibleLikeTests
//
//  Created by Gonzalo Reyes Huertas on 6/5/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import XCTest
import SwiftyJSON
import Firebase
@testable import AudibleLike

class AudibleLikeTests: XCTestCase {
    
    
    // MARK: - User Tests
    
    func testUserCreateWithNameAndUsername() {
        let user = User(name: "Gonzalo", username: "gonzalorehu")
        let name = user.name
        let username = user.username
        XCTAssertEqual(name, "Gonzalo")
        XCTAssertEqual(username, "gonzalorehu")
    }
    
    func testUserCreateWithBlankNameAndUsername() {
        let user = User(name: "", username: "")
        XCTAssertNil(user.name)
        XCTAssertNil(user.username)
    }
    
    func testUserCreateWithoutNameNorUsername() {
        let user = User(name: nil, username: nil)
        XCTAssertNil(user.name)
        XCTAssertNil(user.username)
    }
    
    func testUserCreateWithNameAndUsernameFromJSON() {
        let json = JSON(["nombre":"Gonzalo", "usuario":"gonzalorehu"])
        var user: User?
        do {
            user = try User(json: json)
        } catch {
            print(error)
        }
        XCTAssertEqual(json["nombre"].stringValue, user?.name)
        XCTAssertEqual(json["usuario"].stringValue, user?.username)
    }
    
    func testUserCreateWithoutNameNorUsernameFromJSON() {
        let json = JSON([])
        var user: User?
        do {
            user = try User(json: json)
        } catch {
            print(error)
        }
        XCTAssertNil(user?.name)
        XCTAssertNil(user?.username)
    }
    
    
    // MARK: - Credential Tests
    
    func testCredentialCreateWithoutResult() {
        let json = JSON([])
        var credential: Credential?
        do{
            credential = try Credential(json: json)
        } catch {
            print(error)
        }
        XCTAssertEqual(credential?.result, false)
    }
    
    func testCredentialCreateWithResultFromJSON() {
        let json = JSON(["resultado":true])
        var credential: Credential?
        do{
            credential = try Credential(json: json)
        } catch {
            print(error)
        }
        XCTAssertEqual(credential?.result, true)
    }
    
    
    // MARK: - Lost Tests
    
    func testLostCreateWithParameters() {
        let lost = Lost(firstname: "Gonzalo", lastname: "Reyes Huertas", dni: "72533800", age: 20, description: "Ayy lmao")
        XCTAssertEqual(lost.firstname, "Gonzalo")
        XCTAssertEqual(lost.lastname, "Reyes Huertas")
        XCTAssertEqual(lost.dni, "72533800")
        XCTAssertEqual(lost.age, 20)
        XCTAssertEqual(lost.description, "Ayy lmao")
    }
    
    func testLostCreateWithParametersFromJSON() {
        let json = JSON(["nombre":"Gonzalo",
                         "apellido":"Reyes Huertas",
                         "dni":"72533800",
                         "age":20,
                         "description":"Ayy lmao"])
        var lost:Lost?
        do{
            lost = try Lost(json: json)
        }catch {
            print(error)
        }
        XCTAssertEqual(lost?.firstname, json["nombre"].stringValue)
        XCTAssertEqual(lost?.lastname, json["apellido"].stringValue)
        XCTAssertEqual(lost?.dni, json["dni"].stringValue)
        XCTAssertEqual(lost?.age, json["age"].intValue)
        XCTAssertEqual(lost?.description, json["description"].stringValue)
    }
    
    // MARK: - LostCategory Tests
    
    func testLostCategoryCreateWithNameAndEmptyLostArray() {
        let category = LostCategory(name: "Mayores de 60", lostArray: [])
        XCTAssertEqual(category.name, "Mayores de 60")
        XCTAssert(category.lostArray != nil)
        XCTAssert(category.lostArray?.count == 0)
    }
    
    func testLostCategoryCreateWithNameAndNilLostArray() {
        let category = LostCategory(name: "Mayores de 60", lostArray: nil)
        XCTAssertEqual(category.name, "Mayores de 60")
        XCTAssertNil(category.lostArray)
    }
}
