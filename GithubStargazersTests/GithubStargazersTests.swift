//
//  GithubStargazersTests.swift
//  GithubStargazersTests
//
//  Created by Luigi Borchia on 13/05/21.
//

import XCTest
@testable import GithubStargazers

class GithubStargazersTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //test the API call with mock data
    func testValidApiCall() throws {
        let urlStr = "https://api.github.com/repos/luibo/prototype/stargazers?per_page=25&page=1"
        let url = URL(string: urlStr)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        task.resume()
        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
