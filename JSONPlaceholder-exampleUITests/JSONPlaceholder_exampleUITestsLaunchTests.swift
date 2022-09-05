//
//  JSONPlaceholder_exampleUITestsLaunchTests.swift
//  JSONPlaceholder-exampleUITests
//
//  Created by Victor Castro on 2/09/22.
//

import XCTest

class JSONPlaceholder_exampleUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "LaunchScreen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
