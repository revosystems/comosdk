import Foundation

extension Como {
    public struct Customer : Codable {
        let phoneNumber:String?
        let email:String?
        let appClientId:String?
        let customIdentifier:String?
        
        public init(phoneNumber:String){
            email = nil; appClientId = nil; customIdentifier = nil;
            self.phoneNumber = phoneNumber
        }
        
        public init(email:String){
            phoneNumber = nil; appClientId = nil;  customIdentifier = nil;
            self.email = email
        }
        
        public init(appClientId:String){
            email = nil; phoneNumber = nil;  customIdentifier = nil;
            self.appClientId = appClientId
        }
        
        public init(customIdentifier:String){
            email = nil; phoneNumber = nil;  appClientId = nil;
            self.customIdentifier = customIdentifier
        }
    }
    
}
