import Foundation

extension Como {
    
    public class MemberDetailsResponse : Como.Api.Response  {
        let membership:Membership!
        let memberNotes:[MemberNote]?
        
        private enum CodingKeys: String, CodingKey {
            case membership, memberNotes
        }
        
        required init(from decoder: Decoder) throws {
            let container   = try decoder.container(keyedBy: CodingKeys.self)
            membership      = try container.decodeIfPresent(Membership.self, forKey: .membership)
            memberNotes     = try container.decodeIfPresent([MemberNote].self, forKey: .memberNotes)
            try super.init(from: decoder)
        }
    }

    public struct MemberNote:Codable {
        let content:String
        let type:String
    }
    
    public enum MemberShipStatus : String, Codable {
        case active = "Active", inactive = "Inactive"
    }
    
    public struct Membership : Codable {
        let firstName:String?
        let lastName:String?
        let birthday:String?
        let email:String?
        let gender:String?
        let phoneNumber:String?
        let status:MemberShipStatus
        let createdOn:Date?
        let allowSMS:Bool?
        let allowEmail:Bool?
        let termsOfUse:Bool?
        let gdpr:Bool?
        let commonExtId:String
        let pointsBalance:Balance?
        let creditBalance:Balance?
        let tags:[String]?
        let assets:[Asset]?
        
        public var fullName : String? {
            guard let firstName = firstName else {
                return nil
            }
            return firstName + " " + (lastName ?? "")
        }
        
        public var customer:Como.Customer {
            if let phoneNumber {
                return Como.Customer(phoneNumber: phoneNumber)
            }
            if let email {
                return Como.Customer(email: email)
            }
            return Como.Customer(phoneNumber: "")
        }
    }

    public struct Balance:Codable {
        let usedByPayment:Bool
        let balance:Monetary
    }
    
    public struct Monetary:Codable {
        let monetary:Int
        let nonMonetary:Int
    }
    
    public enum AssetStatus : String, Codable {
        case active = "Active", redeemed = "Reedemed", deactivated = "Deactivated", expired = "Expired", future = "Future", inProgress = "In Progress"
    }
    
    public struct Asset:Codable{
        let key:String
        let name:String
        let description: String?
        let status:AssetStatus
        let image: String?
        let validFrom:Date?
        let validUntil:Date?
        let redeemable:Bool
        let nonRedeemableCause:NonRedeemableCause?
    }
    
    public struct NonRedeemableCause:Codable {
        let code:String
        let message:String
    }
}
