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
         "membership": {
             "firstName": "Jane",
             "lastName": "Smith",
             "birthday": "1995-03-03",
             "email": "jane@email.com",
             "gender": "female",
             "phoneNumber": "2128782328",
             "status": "Active",
             "createdOn": "2016-05-19T10:19:08Z",
             "allowSMS": true,
             "commonExtId": "1d722661-0a94-4a36-8dea-ae23e5e3f440",
             "mobileAppUsed": true,
             "mobileAppUsedLastDate": "2017-06-15T10:12:29Z",
             "pointsBalance": {
                 "usedByPayment": false,
                 "balance": {
                     "monetary": 2000,
                     "nonMonetary": 2000
                 }
             },
             "creditBalance": {
                 "usedByPayment": true,
                 "balance": {
                     "monetary": 1000,
                     "nonMonetary": 1000
                 }
             },
             "tags": ["VIP", "Vegetarian"],
             "assets": [
                 {
                     "key": "60y4KJDxK2zfUrcrir9D3K2OWyvorXpPJADNroNY8",
                     "name": " 10% Off - Coffee Only!",
                     "description": "10% Off for coffee products only",
                     "status": "Active",
                     "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                     "validFrom": "2017-01-05T20:59:59Z",
                     "validUntil": "2017-08-05T20:59:59Z",
                     "redeemable": true
                 },
                 {
                     "key": "1zikFHzdF1jLPqMXdqrfEkJ2rOAXTX9Cw4BFIfq48",
                     "name": "Sandwich Coupon",
                     "description": "$5 Off Sandwich",
                     "status": "Active",
                     "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                     "validFrom": "2017-01-05T20:59:59Z",
                     "validUntil": "2017-08-05T20:59:59Z",
                     "redeemable": false,
                     "nonRedeemableCause": {
                         "code": "5523",
                         "message": "Violation of asset conditions (no benefits)"
                     }
                 },
                 {
                     "key": "ps_6434757946179584_9f9fb0ddb9b278cbfb3d1f1bc95eaadffebb5ccc",
                     "name": "Ice Cream for 60.0 points",
                     "description": "Get free Ice Cream",
                     "status": "Active",
                     "image": "https://storage-download.googleapis.com/server-prod/images/giftimg.jpg",
                     "validUntil": "2017-08-05T20:59:59Z",
                     "redeemable": true
                 }
             ]
         },
         "memberNotes":[
             {
             "content": "Deal of the month: 20% off milkshakes",
             "type": "text"
             }
         ]
        }
        """
        
        HttpFake.enable()
        HttpFake.addResponse(response)
        
        let expectation = XCTestExpectation(description:"Como Api Call")
        Como().getMemberDetails(customer: Como.Customer(phoneNumber: "666777888", email: nil), purchase: Como.Purchase()) { result in
            print(result)
            XCTAssertEqual("Jane", try! result.get().membership.firstName)
            XCTAssertEqual("Deal of the month: 20% off milkshakes", try! result.get().memberNotes.first!.content)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_get_benefits() throws {
        let response = """
        {
            "status": "ok",
            "deals": [
                {
                    "key": "4EGtHYXmIGHUR6wgf7PsH09CHt9C4gUYrA9BSVakMA8",
                    "name": "5% off Deal",
                    "benefits": [
                        {
                            "type": "discount",
                            "sum": -60,
                            "extendedData": [
                                {
                                    "item": {
                                        "code": "1111",
                                        "action": "sale",
                                        "quantity": 5,
                                        "netAmount": 1000,
                                        "lineId": "1"
                                    },
                                    "discount": -50,
                                    "discountedQuantity": 5,
                                    "discountAllocation": [
                                        {
                                            "quantity": 5,
                                            "unitDiscount": -10
                                        }
                                    ]
                                },
                                {
                                    "item": {
                                        "code": "5555",
                                        "action": "sale",
                                        "quantity": 1,
                                        "netAmount": 200,
                                        "lineId": "2"
                                    },
                                    "discount": -10,
                                    "discountedQuantity": 1,
                                    "discountAllocation": [
                                        {
                                            "quantity": 1,
                                            "unitDiscount": -10
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "redeemAssets": [
                {
                    "key": "30yj439fK2zfUrcrir9D37n3kf8orXpPJADN8fnj56",
                    "name": "Deal Code",
                    "redeemable": true,
                    "benefits": [
                        {
                            "type": "dealCode",
                            "code": "65430"
                        }
                    ]
                },
                {
                    "key": "2DmlFX3eGFnMP6QYd63dEUF2ptsMPm6i2hNHfrA8",
                    "code": "27722",
                    "name": "10% off - coffee only",
                    "redeemable": true,
                    "benefits": [
                        {
                            "type": "discount",
                            "sum": -100,
                            "extendedData": [
                                {
                                    "item": {
                                        "code": "1111",
                                        "action": "sale",
                                        "quantity": 5,
                                        "netAmount": 1000,
                                        "lineId": "1"
                                    },
                                    "discount": -100,
                                    "discountedQuantity": 5,
                                    "discountAllocation": [
                                        {
                                            "quantity": 5,
                                            "unitDiscount": -20
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            "totalDiscountsSum": -160
        }
        """
        
        HttpFake.enable()
        HttpFake.addResponse(response)
        
        let expectation = XCTestExpectation(description:"Como Api Call")
        Como().getBenefits(customers: [Como.Customer(phoneNumber: "666777888", email: nil)], purchase: Como.Purchase(), redeemAssets: [Como.RedeemAsset(key:"124", code:nil)]) { result in
            print(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_quick_register() throws {
        let expectation = XCTestExpectation(description:"Como Api Call")
        Como().quickRegister(phoneNumber: "666777888", authCode: "1234") { result in
            print(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_can_submit_event() throws {
        let expectation = XCTestExpectation(description:"Como Api Call")
        Como().submitEvent { result in
            print("done")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
