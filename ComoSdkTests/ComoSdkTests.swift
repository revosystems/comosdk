//
//  ComoSdkTests.swift
//  ComoSdkTests
//
//  Created by Jordi Puigdellívol on 23/6/22.
//

import XCTest
import RevoHttp

@testable import ComoSdk

class ComoSdkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_can_get_member_details() throws {
        let response = """
        {
            "status": "ok",
            "memberNotes": [{
                "content": "Deal of the month: 20% off milkshakes",
                "type": "text"
            }]
        }
        """
        
        HttpFake.enable()
        HttpFake.addResponse(response)
        
        let expectation = XCTestExpectation(description:"Como Api Call")
        ComoApi().getMemberDetails(customer: ComoCustomer(phoneNumber: "666777888", email: nil), purchase: ComoPurchase()) { result in
            print(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_quick_register() throws {
        let expectation = XCTestExpectation(description:"Como Api Call")
        ComoApi().quickRegister(phoneNumber: "666777888", authCode: "1234") { result in
            print(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
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
