
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
            payments        = try container.decode([Payment].self, forKey: .payments)
            confirmation    = try container.decode(String.self, forKey: .confirmation)
            type            = try container.decode(String.self, forKey: .type)
            updatedBalance  = try container.decode(Monetary.self, forKey: .updatedBalance)
            try super.init(from: decoder)
        }
    }
    
    public struct Payment : Codable {
        
    }
}
