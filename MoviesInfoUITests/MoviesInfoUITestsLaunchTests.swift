//
//  MoviesInfoUITestsLaunchTests.swift
//  MoviesInfoUITests
//
//  Created by Tobias Ruano on 07/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import XCTest

class MoviesInfoUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
