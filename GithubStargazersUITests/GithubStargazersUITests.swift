//
//  GithubStargazersUITests.swift
//  GithubStargazersUITests
//
//  Created by Luigi Borchia on 13/05/21.
//

import XCTest

@testable import GithubStargazers

class GithubStargazersUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    

    func testSearchButton() throws {
        let ownerTextField = app.textFields["Owner"]
        let repoTextField = app.textFields["Repository"]
        let searchButton = app.buttons["Search"]
        
        XCTAssertFalse(searchButton.isEnabled)
        
        if !ownerTextField.isFocused {
            ownerTextField.tap()
            ownerTextField.typeText("luibo")
        }
    
        XCTAssertFalse(searchButton.isEnabled)
        
        if !repoTextField.isFocused {
            repoTextField.tap()
            repoTextField.typeText("prototype")
        }
        
        XCTAssertTrue(searchButton.isEnabled)
    }
    
}

extension XCUIElement {
    var isFocused: Bool {
        let isFocused = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return isFocused
    }
}
