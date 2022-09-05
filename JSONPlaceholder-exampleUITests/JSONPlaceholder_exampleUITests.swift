//
//  JSONPlaceholder_exampleUITests.swift
//  JSONPlaceholder-exampleUITests
//
//  Created by Victor Castro on 2/09/22.
//

import XCTest

class JSONPlaceholder_exampleUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func tests_should_download_post_from_api() throws {

        let downloadButton = app.buttons["idDownloadPostFromApi"]
        downloadButton.tap()
        
        let deleteAllButton = app.buttons["idDeleteAll"]
        XCTAssert(deleteAllButton.waitForExistence(timeout: 0.5))
    }
    
    func tests_should_remove_one_post() throws {
        let postRows = app.tables["idPostsList"].cells
        let row = Int.random(in: 0..<5)
        let currentPosts = postRows.count
        postRows.element(boundBy: row).swipeLeft()
        postRows.element(boundBy: row).swipeLeft()

        XCTAssertTrue(currentPosts - postRows.count == 1)
    }
    
    func tests_should_add_favorite_post() throws {
        let postRows = app.tables["idPostsList"].cells
        let row = Int.random(in: 0..<5)
        postRows.element(boundBy: row).swipeRight()
        postRows.element(boundBy: row).swipeRight()
    }

    func tests_should_open_details_of_post() throws {
        let postRow = app.buttons["idPost"]
        postRow.firstMatch.tap()
        
        let content = app.staticTexts["Description"]
        
        XCTAssert(content.waitForExistence(timeout: 0.5))
    }
}
