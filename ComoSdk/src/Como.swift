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
    
    public func payment(customer:Customer, purchase:Purchase, code:String? = nil, amount:Int, then:@escaping(Result<PaymentResponse, Error>) -> Void){
        
        struct Payment : Codable {
            let customer:Customer
            let purchase:Purchase
            let code:String?
            let amount:Int
        }
        
        let object = Payment(customer: customer, purchase: purchase, code:code, amount:amount)
                      
        api.post("payment", object:object, then:then)
    }
    
    public func cancelPayment(){
        //TODO
    }
    
    public func submit(purchase:Como.Purchase, customer:Como.Customer? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil, closed:Bool = false, then:@escaping(Result<Como.SubmitPurchaseResponse, Error>) -> Void){
        struct SubmitPurchase:Codable {
            let customer:Customer?
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]?
            let deals:[RedeemAsset]?
        }
        let append = closed ? "" : "?status=open"
        api.post("submitPurchase" + append, object:SubmitPurchase(customer:customer, purchase: purchase, redeemAssets: assets, deals: deals), then:then)
    }
    
    public func submit(purchase:Como.Purchase, customer:Como.Customer? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil, then:@escaping(Result<Como.SubmitPurchaseResponse, Error>) -> Void){
        submit(purchase: purchase, customer: customer, assets: assets, deals: deals, closed: true, then: then)
    }
    
    public func void(purchase:Como.Purchase, then:@escaping(Result<Como.Api.Response, Error>) -> Void){
        struct VoidPurchase : Codable {
            let purchase:Purchase
        }
        
        api.post("voidPurchase", object:VoidPurchase(purchase: purchase), then:then)
    }
    
    public func sendIdentificationCode(){
        //TODO
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
