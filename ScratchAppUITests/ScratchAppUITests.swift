//
//  ScratchAppUITests.swift
//  ScratchAppUITests
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import XCTest
var app: XCUIApplication!

class ScratchAppUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNavBarTitle() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let navTitleIdentifier = "StackOverflow Users"
        let navigationTitleElement = app.navigationBars.matching(identifier: navTitleIdentifier).firstMatch
        XCTAssert(navigationTitleElement.exists)
                                                                
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
