//
//  ComoSdkTests.swift
//  ComoSdkTests
//
//  Created by Jordi Puigdellívol on 23/6/22.
//

import XCTest
@testable import ComoSdk

class ComoSdkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_can_submit_event() throws {
        let expectation = XCTestExpectation(description:"Como Api Call")
        ComoApi().submitEvent { result in
            print("done")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
