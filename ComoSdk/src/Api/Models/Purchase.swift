import Foundation

extension Como {
    public struct Purchase : Codable {
        public let openTime:Date
        public let transactionId:String
        public let totalAmount:Int
        public let orderType:String
        public let employee:String
        public let items:[PurchaseLine]
        
        public init(openTime:Date, transactionId:String, totalAmount:Int, orderType:String, employee:String, items:[PurchaseLine]){
            self.openTime = openTime; self.transactionId = transactionId; self.totalAmount = totalAmount; self.orderType = orderType; self.employee = employee; self.items = items;
        }
        
        static func fake() -> Purchase {
            return Purchase(openTime: Date(), transactionId: "\(Int.random(in: 0...9999))", totalAmount: 200, orderType: "dineIn", employee: "Jordi", items: [PurchaseLine.fake()])
        }
    }

    
    public struct PurchaseLine : Codable {
        public let lineId:String
        public let code:String
        public let name:String
        public let departmentCode:String
        public let departmentName:String
        public let quantity:Int
        public let grossAmount:Int
        public let netAmount:Int
        
        public init(lineId:String, code:String, name:String, departmentCode:String, departmentName:String, quantity:Int, grossAmount:Int, netAmount:Int){
            self.lineId = lineId; self.code = code; self.name = name; self.departmentCode = departmentCode; self.departmentName = departmentName; self.quantity = quantity; self.grossAmount = grossAmount; self.netAmount = netAmount
        }
        
        static func fake() -> PurchaseLine {
            PurchaseLine(lineId: "1", code: "12", name: "Item 1", departmentCode: "1", departmentName: "Category 1", quantity: 1, grossAmount: 100, netAmount: 100)
        }
    }
}
