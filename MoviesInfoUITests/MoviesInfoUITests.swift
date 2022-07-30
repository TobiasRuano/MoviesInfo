//
//  MoviesInfoUITests.swift
//  MoviesInfoUITests
//
//  Created by Tobias Ruano on 07/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import XCTest

class MoviesInfoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTitleChangeOnEndpointChange() {
        let app = XCUIApplication()
        app.launch()
        let nowPlayingNavigationBar = app.navigationBars["Now Playing"]
        XCTAssertTrue(nowPlayingNavigationBar.exists)
        nowPlayingNavigationBar.buttons["more"].tap()
        
        let elementsQuery = app.sheets["Choose an option:"].scrollViews.otherElements
        elementsQuery.buttons["Upcoming"].tap()
        
        let upcomingNavigationBar = app.navigationBars["Upcoming"]
        XCTAssertTrue(upcomingNavigationBar.exists)
        upcomingNavigationBar.buttons["more"].tap()
        elementsQuery.buttons["Top Rated"].tap()
        
        let topRatedNavigationBar = app.navigationBars["Top Rated"]
        XCTAssertTrue(topRatedNavigationBar.exists)
        topRatedNavigationBar.buttons["more"].tap()
        elementsQuery.buttons["Popular"].tap()
        
        let popularNavigationBar = app.navigationBars["Popular"]
        XCTAssertTrue(popularNavigationBar.exists)
    }
}
