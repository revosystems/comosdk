import Foundation

extension Como {
    public struct Purchase : Codable {
        let openTime:Date
        let transactionId:String
        let totalAmount:Int
        let orderType:String
        let employee:String
        let items:[PurchaseLine]
        
        static func fake() -> Purchase {
            return Purchase(openTime: Date(), transactionId: "\(Int.random(in: 0...9999))", totalAmount: 200, orderType: "dineIn", employee: "Jordi", items: [PurchaseLine.fake()])
        }
    }

    
    public struct PurchaseLine : Codable {
        let lineId:String
        let code:String
        let name:String
        let departmentCode:String
        let departmentName:String
        let quantity:Int
        let grossAmount:Int
        let netAmount:Int
        
        static func fake() -> PurchaseLine {
            PurchaseLine(lineId: "1", code: "12", name: "Item 1", departmentCode: "1", departmentName: "Category 1", quantity: 1, grossAmount: 100, netAmount: 100)
        }
    }
}
