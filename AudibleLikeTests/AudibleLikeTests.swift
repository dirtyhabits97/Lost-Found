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
    
    func testUserCreateWithNameAndUsername() {
        let user = User(name: "Gonzalo", username: "gonzalorehu")
        let name = user.name
        let username = user.username
        XCTAssertEqual(name, "Gonzalo")
        XCTAssertEqual(username, "gonzalorehu")
    }
    
}
