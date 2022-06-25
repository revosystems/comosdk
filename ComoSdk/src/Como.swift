import Foundation

public class Como {
    
    let api:Api = Api()
    
    //MARK: - Methods
    public func getMemberDetails(customer:Customer, purchase:Purchase, then:@escaping(Result<MemberDetailsResponse, Error>) -> Void){
        
        struct MemberDetails : Codable {
            let customer:Customer
            let purchase:Purchase
        }
        
        let object = MemberDetails(customer: customer, purchase: purchase)
                      
        api.post("getMemberDetails?returnAssets=active&expand=assets.redeemable", object:object, then:then)
    }
    
    public func getBenefits(customers:[Customer], purchase:Purchase, redeemAssets:[RedeemAsset], then:@escaping(Result<GetBenefitsResponse, Error>) -> Void){
        
        struct GetBenefits : Codable {
            let customers:[Customer]
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]
        }
        
        let object = GetBenefits(customers: customers, purchase: purchase, redeemAssets:redeemAssets)
                      
        api.post("getBenefits?expand=discountByDiscount", object:object, then:then)
    }
    
    public func quickRegister(phoneNumber:String, email:String? = nil, authCode:String? = nil, then:@escaping(Result<Como.Api.Response, Error>) -> Void){
                
        struct QuickRegister : Codable {
            let customer:Customer
            let quickRegistrationCode:String?
        }
        
        let object = QuickRegister(customer: Customer(phoneNumber: phoneNumber, email: email), quickRegistrationCode: authCode)
        
        api.post("registration/quick", object:object, then: then)
    }
    
    public func submitEvent(then:@escaping(Result<Como.Api.Response, Error>) -> Void){
        api.post("submitEvent", then:then)
    }
}
