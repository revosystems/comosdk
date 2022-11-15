extension Como {
    
    public class GetBenefitsResponse : Como.Api.Response  {
        public let deals:[Deal]?
        public let redeemAssets:[RedeemAssetResponse]?
        public let totalDiscountsSum:Int?

        private enum CodingKeys: String, CodingKey {
            case totalDiscountsSum, deals, redeemAssets
        }

        required init(from decoder: Decoder) throws {
            let container       = try decoder.container(keyedBy: CodingKeys.self)
            totalDiscountsSum   = try container.decodeIfPresent(Int.self, forKey: .totalDiscountsSum)
            deals               = try container.decodeIfPresent([Deal].self, forKey: .deals)
            redeemAssets        = try container.decodeIfPresent([RedeemAssetResponse].self, forKey: .redeemAssets)
            try super.init(from: decoder)
        }
        
        public func itemCodeBenefits() -> [Benefit]? {
            redeemAssets?.filter {
                $0.redeemable ?? false
            }.compactMap {
                $0.benefits
            }.flatMap {
                $0
            }.filter {
                $0.type == .itemCode
            }
        }
        
        public func errors() -> String? {
            let errors = redeemAssets?.filter { !($0.redeemable ?? false) }.compactMap { $0.nonRedeemableCause?.message }
            if let errors = errors, errors.count > 0 {
                return errors.map { Como.trans("como_\($0)") }.implode(", ")
            }
            return nil
        }
    }
    
    public enum BenefitType : String, Codable {
        case dealCode, itemCode, discount
    }
    
    public struct Deal : Codable {
        public let key:String
        public let name:String
        public let benefits:[Benefit]?
    }
    
    public struct Benefit : Codable {
        public let type:BenefitType
        public let code:String?
        public let sum:Int?
        public let extendedData:[ExtendedData]?
    }
    
    public struct ExtendedData : Codable {
        public let item:Item
        public let discount:Int
        public let discountedQuantity:Int
        public let discountAllocation:[DiscountAllocation]
    }
    
    public struct Item : Codable {
        public let code:String
        public let action:String
        public let quantity:Int
        public let netAmount:Int
        public let lineId:String
    }
    
    public struct DiscountAllocation : Codable {
        public let quantity:Int
        public let unitDiscount:Int
    }
    
    public struct RedeemAssetResponse : Codable {
        public let key:String?
        public let name:String?
        public let code:String?
        public let redeemable:Bool?
        public let nonRedeemableCause:Como.Api.ResponseError?
        public let benefits:[Benefit]?
    }
}
