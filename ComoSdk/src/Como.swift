import Foundation
import UIKit

public class Como {
    
    static var shared:Como = {
        Como()
    }()
    
    let api:Api = Api()
    
    //MARK:Controllers
    public static func controller(purchase:Como.Purchase, delegate:ComoDelegate) -> UINavigationController {
        let nav = ComoController.make()
        (nav.children.first as? ComoController)?.purchase = purchase
        (nav.children.first as? ComoController)?.delegate = delegate
        nav.modalPresentationStyle = .formSheet
        return nav
    }
    
    //MARK: - Methods
    public func getMemberDetails(customer:Customer, purchase:Purchase) async throws -> MemberDetailsResponse{
        
        struct MemberDetails : Codable {
            let customer:Customer
            let purchase:Purchase
        }
        
        let object = MemberDetails(customer: customer, purchase: purchase)
                      
        return try await api.post("getMemberDetails?returnAssets=active&expand=assets.redeemable", object:object)
    }
    
    public func getBenefits(customers:[Customer], purchase:Purchase, redeemAssets:[RedeemAsset]) async throws -> GetBenefitsResponse {
        
        struct GetBenefits : Codable {
            let customers:[Customer]
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]
        }
        
        let object = GetBenefits(customers: customers, purchase: purchase, redeemAssets:redeemAssets)
                      
        return try await api.post("getBenefits?expand=discountByDiscount", object:object)
    }
    
    public func payment(customer:Customer, purchase:Purchase, code:String? = nil, amount:Int) async throws -> PaymentResponse {
        
        struct Payment : Codable {
            let customer:Customer
            let purchase:Purchase
            let code:String?
            let amount:Int
        }
        
        let object = Payment(customer: customer, purchase: purchase, code:code, amount:amount)
                      
        return try await api.post("payment", object:object)
    }
    
    public func cancelPayment(){
        //TODO
    }
    
    public func submit(purchase:Como.Purchase, customer:Como.Customer? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil, closed:Bool = false) async throws -> Como.SubmitPurchaseResponse {
        struct SubmitPurchase:Codable {
            let customer:Customer?
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]?
            let deals:[RedeemAsset]?
        }
        let append = closed ? "" : "?status=open"
        return try await api.post("submitPurchase" + append, object:SubmitPurchase(customer:customer, purchase: purchase, redeemAssets: assets, deals: deals))
    }
    
    public func submit(purchase:Como.Purchase, customer:Como.Customer? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil) async throws -> Como.SubmitPurchaseResponse {
        return try await submit(purchase: purchase, customer: customer, assets: assets, deals: deals, closed: true)
    }
    
    public func void(purchase:Como.Purchase) async throws -> Como.Api.Response {
        struct VoidPurchase : Codable {
            let purchase:Purchase
        }
        
        return try await api.post("voidPurchase", object:VoidPurchase(purchase: purchase))
    }
    
    public func sendIdentificationCode(){
        //TODO
    }
    
    
    
    public func quickRegister(phoneNumber:String, email:String? = nil, authCode:String? = nil) async throws -> Como.Api.Response {
                
        struct QuickRegister : Codable {
            let customer:Customer
            let quickRegistrationCode:String?
        }
        
        let object = QuickRegister(customer: Customer(phoneNumber: phoneNumber, email: email), quickRegistrationCode: authCode)
        
        return try await api.post("registration/quick", object:object)
    }
    
    public func submitEvent() async throws -> Como.Api.Response {
        return try await api.post("submitEvent")
    }
}
