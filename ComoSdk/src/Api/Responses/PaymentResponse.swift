
extension Como {
    
    public class PaymentResponse : Como.Api.Response  {
        let payments:[Payment]!
        let confirmation:String!
        let type:String!
        let updatedBalance:Monetary!
        
        private enum CodingKeys: String, CodingKey {
            case payments, confirmation, type, updatedBalance
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            payments        = try container.decodeIfPresent([Payment].self, forKey: .payments)
            confirmation    = try container.decodeIfPresent(String.self, forKey: .confirmation)
            type            = try container.decodeIfPresent(String.self, forKey: .type)
            updatedBalance  = try container.decodeIfPresent(Monetary.self, forKey: .updatedBalance)
            try super.init(from: decoder)
        }
    }
    
    public struct Payment : Codable {
        public let paymentMethod:String
        public let amount:Int
    }
}
