import Foundation

extension Como {
    
    public enum OrderType:String, Codable {
        case dineIn, delivery, pickup
    }
    
    public struct Purchase : Codable {
        public let openTime:Date
        public var transactionId:String = UUID().uuidString
        public let relatedTransactionId:String?
        public let totalAmount:Int
        public let totalGeneralDiscount:Int?
        public let orderType:OrderType
        public let employee:String
        public let items:[PurchaseLine]
        public var meansOfPayment:[Como.MeanOfPayment]?
        
        public init(openTime:Date, relatedTransactionId:String? ,totalAmount:Int, totalGeneralDiscount:Int? = nil, orderType:OrderType, employee:String, items:[PurchaseLine], payments:[Como.MeanOfPayment]? = nil){
            self.openTime             = openTime
            self.relatedTransactionId = relatedTransactionId
            self.totalAmount          = totalAmount
            self.totalGeneralDiscount = totalGeneralDiscount
            self.orderType            = orderType
            self.employee             = employee
            self.items                = items
            self.meansOfPayment       = payments
        }
        
        static func fake() -> Purchase {
            Purchase(openTime: Date(), relatedTransactionId:"\(Int.random(in: 0...9999))", totalAmount: 200, orderType: .pickup, employee: "Jordi", items: [PurchaseLine.fake()])
        }
        
        
        mutating func add(payments:[Como.MeanOfPayment]){
            if meansOfPayment == nil {
                meansOfPayment = payments
            }
            meansOfPayment?.append(contentsOf: payments)
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
