import Foundation

extension Como {
    
    public class MemberDetailsResponse : Como.Api.Response  {
        public let membership:Membership!
        public let memberNotes:[MemberNote]?
        
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
        public let content:String
        public let type:String
    }
    
    public enum MemberShipStatus : String, Codable {
        case active = "Active", inactive = "Inactive"
    }
    
    public struct Membership : Codable {
        public let firstName:String?
        public let lastName:String?
        public let birthday:String?
        public let email:String?
        public let gender:String?
        public let phoneNumber:String?
        public let status:MemberShipStatus
        public let createdOn:Date?
        public let allowSMS:Bool?
        public let allowEmail:Bool?
        public let termsOfUse:Bool?
        public let gdpr:Bool?
        public let commonExtId:String
        public let pointsBalance:Balance?
        public let creditBalance:Balance?
        public let tags:[String]?
        public let assets:[Asset]?
        
        public var fullName : String? {
            guard let firstName = firstName else {
                return nil
            }
            return firstName + " " + (lastName ?? "")
        }
        
        public var customer:Como.Customer {
            if let phoneNumber, !phoneNumber.isEmpty {
                return Como.Customer(phoneNumber: phoneNumber)
            }
            if let email, !email.isEmpty {
                return Como.Customer(email: email)
            }
            return Como.Customer(phoneNumber: "")
        }
    }

    public struct Balance:Codable {
        public let usedByPayment:Bool
        public let balance:Monetary
    }
    
    public struct Monetary:Codable {
        public let monetary:Int
        public let nonMonetary:Int
    }
    
    public enum AssetStatus : String, Codable {
        case active = "Active", redeemed = "Reedemed", deactivated = "Deactivated", expired = "Expired", future = "Future", inProgress = "In Progress"
    }
    
    public struct Asset:Codable{
        public let key:String
        public let name:String
        public let description: String?
        public let status:AssetStatus
        public let image: String?
        public let validFrom:Date?
        public let validUntil:Date?
        public let redeemable:Bool
        public let nonRedeemableCause:NonRedeemableCause?
    }
    
    public struct NonRedeemableCause:Codable {
        public let code:String
        public let message:String
    }
}
