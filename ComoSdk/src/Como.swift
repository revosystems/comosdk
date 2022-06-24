import Foundation

public class Como {
    
    let api:Api = Api()
    
    //MARK: - Methods
    public func getMemberDetails(customer:ComoCustomer, purchase:ComoPurchase, then:@escaping(Result<MemberDetailsResponse, Error>) -> Void){
        
        struct MemberDetails : Codable {
            let customer:ComoCustomer
            let purchase:ComoPurchase
        }
        
        let object = MemberDetails(customer: customer, purchase: purchase)
                      
        api.post("getMemberDetails?returnAssets=active&expand=assets.redeemable", object:object, then:then)
    }
    
    public func quickRegister(phoneNumber:String, email:String? = nil, authCode:String? = nil, then:@escaping(Result<Como.Api.Response, Error>) -> Void){
                
        struct QuickRegister : Codable {
            let customer:ComoCustomer
            let quickRegistrationCode:String?
        }
        
        let object = QuickRegister(customer: ComoCustomer(phoneNumber: phoneNumber, email: email), quickRegistrationCode: authCode)
        
        api.post("registration/quick", object:object, then: then)
    }
    
    public func submitEvent(then:@escaping(Result<Como.Api.Response, Error>) -> Void){
        api.post("submitEvent", then:then)
    }
}
