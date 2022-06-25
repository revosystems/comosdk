extension Como {
    
    public class GetBenefitsResponse : Como.Api.Response  {
        let deals:[Deal]
        let redeemAssets:[RedeemAssetResponse]
        let totalDiscountsSum:Int

        private enum CodingKeys: String, CodingKey {
            case totalDiscountsSum, deals, redeemAssets
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            totalDiscountsSum = try container.decode(Int.self, forKey: .totalDiscountsSum)
            deals = try container.decode([Deal].self, forKey: .deals)
            redeemAssets = try container.decode([RedeemAssetResponse].self, forKey: .redeemAssets)
            try super.init(from: decoder)
        }
    }
    
    public struct Deal : Codable {
        let key:String
        let name:String
        let benefits:[Benefit]
    }
    
    public struct Benefit : Codable {
        let type:String
        let code:String?
        let sum:Int?
        let extendedData:[ExtendedData]?
    }
    
    public struct ExtendedData : Codable {
        let item:Item
        let discount:Int
        let discountedQuantity:Int
        let discountAllocation:[DiscountAllocation]
    }
    
    public struct Item : Codable {
        let code:String
        let action:String
        let quantity:Int
        let netAmount:Int
        let lineId:String
    }
    
    public struct DiscountAllocation : Codable {
        let quantity:Int
        let unitDiscount:Int
    }
    
    public struct RedeemAssetResponse : Codable {
        let key:String
        let name:String
        let code:String?
        let redeemable:Bool
        let benefits:[Benefit]
    }        
}
