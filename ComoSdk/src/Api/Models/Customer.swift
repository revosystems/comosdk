import Foundation

extension Como {
    public struct Customer : Codable {
        let phoneNumber:String?
        let email:String?
        let firstName:String?
        let lastName:String?
        let appClientId:String?
        let commonExtId:String?
        
        public init(phone:String?, email:String?, firstName:String?, lastName:String?, appClientId:String? = nil, commmonExtId:String? = nil){
            self.phoneNumber = phone
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.appClientId = appClientId
            self.commonExtId = commmonExtId
        }
        
        public init(membership:Membership){
            self.phoneNumber = membership.phoneNumber
            self.email = membership.email
            self.firstName = membership.firstName
            self.lastName = membership.lastName
            self.commonExtId = membership.commonExtId
            self.appClientId = nil
        }
        
        public init(phoneNumber:String){
            email = nil; appClientId = nil; commonExtId = nil; firstName = nil; lastName = nil;
            self.phoneNumber = phoneNumber
        }
        
        public init(email:String){
            phoneNumber = nil; appClientId = nil;  commonExtId = nil; firstName = nil; lastName = nil;
            self.email = email
        }
        
        public init(appClientId:String){
            email = nil; phoneNumber = nil;  commonExtId = nil; firstName = nil; lastName = nil;
            self.appClientId = appClientId
        }
        
        public init(commonExtId:String){
            email = nil; phoneNumber = nil;  appClientId = nil; firstName = nil; lastName = nil;
            self.commonExtId = commonExtId
        }
        
        public var display: String {
            phoneNumber ?? email ?? appClientId ?? commonExtId ?? "--"
        }
    }
    
}
