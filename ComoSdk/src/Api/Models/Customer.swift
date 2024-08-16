import Foundation

extension Como {
    public struct Customer : Codable {
        let phoneNumber:String?
        let email:String?
        let appClientId:String?
        let commonExtId:String?
        
        public init(phoneNumber:String){
            email = nil; appClientId = nil; commonExtId = nil;
            self.phoneNumber = phoneNumber
        }
        
        public init(email:String){
            phoneNumber = nil; appClientId = nil;  commonExtId = nil;
            self.email = email
        }
        
        public init(appClientId:String){
            email = nil; phoneNumber = nil;  commonExtId = nil;
            self.appClientId = appClientId
        }
        
        public init(commonExtId:String){
            email = nil; phoneNumber = nil;  appClientId = nil;
            self.commonExtId = commonExtId
        }
        
        public var display: String {
            phoneNumber ?? email ?? appClientId ?? commonExtId ?? "--"
        }
    }
    
}
