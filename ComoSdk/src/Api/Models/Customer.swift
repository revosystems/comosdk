import Foundation

extension Como {
    public struct Customer : Codable {
        let phoneNumber:String?
        let email:String?
        let appClientId:String?
        
        public init(phoneNumber:String){
            email = nil; appClientId = nil
            self.phoneNumber = phoneNumber
        }
        
        public init(email:String){
            phoneNumber = nil; appClientId = nil
            self.email = email
        }
        
        public init(appClientId:String){
            email = nil; phoneNumber = nil
            self.appClientId = appClientId
        }
    }
    
}
