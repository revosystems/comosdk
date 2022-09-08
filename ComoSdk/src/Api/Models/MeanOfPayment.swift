import Foundation

extension Como {
    public struct MeanOfPayment : Codable {
        public let type:String
        public let amount:Int
        
        public init(type:String, amount:Int){
            self.type = type; self.amount = amount
        }
    }
}
