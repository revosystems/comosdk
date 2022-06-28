import Foundation

extension Como {
    
    public class SubmitPurchaseResponse : Como.Api.Response  {
        let confirmation:String?
        
        private enum CodingKeys: String, CodingKey {
            case confirmation
        }
        
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            confirmation        = try container.decodeIfPresent(String.self, forKey: .confirmation)            
            try super.init(from: decoder)
        }
    }
}
