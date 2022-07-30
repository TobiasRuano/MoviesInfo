//
//  SearchViewUITests.swift
//  MoviesInfoUITests
//
//  Created by Tobias Ruano on 09/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import XCTest

class SearchViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchFieldShowsAfterCancel() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Search"].tap()
        
        let searchNavigationBar = app.navigationBars["Search"]
        let searchAMovieSearchField = searchNavigationBar.searchFields["Search a Movie"]
        searchAMovieSearchField.tap()
        let keybord = app.keyboards
        XCTAssertTrue(keybord.count > 0)
        searchAMovieSearchField.typeText("Spiderman")
        app.keyboards.buttons["Search"].tap()
        
        testKeyboardDissmiss()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 8).swipeUp()
        
        let cancelButton = searchNavigationBar.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()
        
        XCTAssertTrue(searchAMovieSearchField.exists)
    }
    
    func testKeyboardDissmiss() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Search"].tap()
        
        let searchNavigationBar = app.navigationBars["Search"]
        let searchAMovieSearchField = searchNavigationBar.searchFields["Search a Movie"]
        searchAMovieSearchField.tap()
        let keybord = app.keyboards
        XCTAssertTrue(keybord.count > 0)
        searchAMovieSearchField.typeText("Spiderman")
        app.keyboards.buttons["Search"].tap()
        
        XCTAssertTrue(keybord.element.exists)
    }

}
