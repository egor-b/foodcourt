//
//  ModelTests.swift
//  foodsterTests
//
//  Created by Egor Bryzgalov on 10/9/20.
//

import XCTest
@testable import foodster

class ModelTests: XCTestCase {

    func testInitRecipeModel() {
        let recipe =  Recipe(name: "Name 1", time: 40, serve: 2, level: 3, type: "meat", about: "mwoeigw",
                             visible: true, food: [Food(name: "123", count: 2.3, messuer: "eee")],
                                                   step: [Step(stepNumber: 1, steDescription: "q")])
        
        XCTAssertNotNil(recipe)
        XCTAssertNotNil(recipe.timaStamp)
        XCTAssertEqual(recipe.lang, Locale.current.languageCode)
        XCTAssertEqual(recipe.name, "Name 1")
    }

}
