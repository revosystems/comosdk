
extension Como {
    
    public class PaymentResponse : Como.Api.Response  {
        public let payments:[Payment]!
        public let confirmation:String!
        public let type:String!
        public let updatedBalance:Monetary!
        
        private enum CodingKeys: String, CodingKey {
            case payments, confirmation, type, updatedBalance
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            payments        = try container.decodeIfPresent([Payment].self,   forKey: .payments)
            confirmation    = try container.decodeIfPresent(String.self,      forKey: .confirmation)
            type            = try container.decodeIfPresent(String.self,      forKey: .type)
            updatedBalance  = try container.decodeIfPresent(Monetary.self,    forKey: .updatedBalance)
            try super.init(from: decoder)
        }
    }
    
    public struct Payment : Codable {
        public let paymentMethod:String
        public let amount:Int
    }
    
    public enum PaymentType: String, Codable {
        case memberCredit, memberPoints, creditCard
    }
    
    public class CancelPaymentResponse : Como.Api.Response {
        public let type:PaymentType
        public let updatedBalance:Monetary
        
        private enum CodingKeys: String, CodingKey {
            case type, updatedBalance
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            type            = try container.decode(PaymentType.self, forKey: .type)
            updatedBalance  = try container.decode(Monetary.self,    forKey: .updatedBalance)
            try super.init(from: decoder)
        }
    }
}
