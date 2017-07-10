//
//  AudibleLikeTests.swift
//  AudibleLikeTests
//
//  Created by Gonzalo Reyes Huertas on 6/5/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import XCTest
@testable import SnapKit
@testable import AudibleLike

class AudibleLikeTests: XCTestCase {
    
    
    // MARK: - User Tests
    
    func testUserCreateWithParams() {
        let user = User(name: "Gonzalo", username: "gonzalorehu")
        let name = user.name
        let username = user.username
        XCTAssertEqual(name, "Gonzalo")
        XCTAssertEqual(username, "gonzalorehu")
        XCTAssertEqual(user.age, 0)
        XCTAssertEqual(user.dni, "")
        XCTAssertEqual(user.email, "")
    }
    
    func testUserDictionary() {
        let dictionary = [
            "dni": "72533800",
            "email": "gonzalorh.97.31@gmail.com",
            "usuario": "gonzalorehu",
            "edad": 20,
            "nombre": "Gonzalo"
        ] as [String : Any]
        let user = User(dictionary: dictionary)
        XCTAssertEqual(user.name, "Gonzalo")
        XCTAssertEqual(user.username, "gonzalorehu")
        XCTAssertEqual(user.age, 20)
        XCTAssertEqual(user.dni, "72533800")
        XCTAssertEqual(user.email, "gonzalorh.97.31@gmail.com")
        
    }
    
    func testPages() {
        let page = Page("title", "message", "")
        XCTAssertEqual("title", page.title)
        XCTAssertEqual("", page.imageName)
        XCTAssertEqual("message", page.message)
    }
    
    func testLostPersonParams() {
        let lost = Lost(firstname: "Person", lastname: "1", dni: "00000000", age: 27, description: "desc")
        XCTAssertEqual("Person", lost.firstname)
        XCTAssertEqual("1", lost.lastname)
        XCTAssertEqual("00000000", lost.dni)
        XCTAssertEqual(27, lost.age)
        XCTAssertEqual("desc", lost.description)
        XCTAssertEqual(0, lost.longitude)
        XCTAssertEqual(0, lost.latitude)
    }
    
    func testLostPersonDictionary() {
        let dictionary = [
            "latitude": -12.0855081,
            "firstname": "Maria",
            "dni": "98928392",
            "lastname": "Perales",
            "descripcion": "desc",
            "longitude": -76.9718187,
            "edad": 25,
            "imagen": "-"
        ] as [String : Any]
        let lost = Lost(dictionary: dictionary)
        XCTAssertEqual("Maria", lost.firstname)
        XCTAssertEqual("Perales", lost.lastname)
        XCTAssertEqual("98928392", lost.dni)
        XCTAssertEqual(25, lost.age)
        XCTAssertEqual("desc", lost.description)
        XCTAssertEqual(-76.9718187, lost.longitude)
        XCTAssertEqual(-12.0855081, lost.latitude)
    }
    
    func testLostCategoryParams() {
        let cat = LostCategory(name: "Cat 1", lostArray: nil)
        XCTAssertEqual(cat.name, "Cat 1")
        XCTAssertNil(cat.lostArray)
    }
    
    func testLostCategoryDictionary() {
        let dictionary = ["name": "Cat 1"]
        let cat = LostCategory(dictionary: dictionary)
        XCTAssertEqual(cat.name, "Cat 1")
        XCTAssertNil(cat.lostArray)
    }
    
    func testLostCategoriesParam() {
        let cat = Categories(lostCategories: nil)
        XCTAssertNil(cat.lostCategories)
    }
    
    func testLostCategoriesDictionary() {
        let dictionary = [String: Any]()
        let cat = Categories(dictionary: dictionary)
        XCTAssertNil(cat.lostCategories)
    }
    
    func testResultDictionary() {
        let dictionary = [String: String]()
        let result = Result(dictionary: dictionary)
        XCTAssertFalse(result.value)
    }
    
    func testResultDictionaryTrue() {
        let dictionary = ["result": 1]
        let result = Result(dictionary: dictionary)
        XCTAssertFalse(!result.value)
    }
    
    func testNewsDictionary() {
        let dictionary = [
            "teaser": "teaser",
            "imageUrl": "image",
            "content": "12345",
            "title": "title"
        ] as [String: Any]
        let news = News(dictionary: dictionary)
        XCTAssertEqual("teaser", news.teaser)
        XCTAssertEqual("image", news.imageUrl)
        XCTAssertEqual("12345", news.content)
        XCTAssertEqual("title", news.title)
    }
    
    func testNewsEmptyDictionary() {
        let dictionary = [String: String]()
        let news = News(dictionary: dictionary)
        XCTAssertEqual("", news.teaser)
        XCTAssertEqual("", news.imageUrl)
        XCTAssertEqual("", news.content)
        XCTAssertEqual("", news.title)
    }
    
    
}
