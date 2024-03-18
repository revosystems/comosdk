import Foundation
import UIKit
import RevoFoundation

public class Como {
    
    public static var language:String = "es"
    
    public static var shared:Como = {
        Como()
    }()
    
    var api:Api?
    var transactionUuid:String = UUID().uuidString
    
    public var currentSale:CurrentSale?
    
    @discardableResult
    public func setup(key:String, branchId:String, posId:String, source:String, sourceVersion:String, language:String = "es", debug:Bool = false, url:String = "https://api.prod.bcomo.com/api/v4/") -> Self {
        api = Api(key:key, branchId: branchId, posId: posId, source: source, sourceVersion: sourceVersion, debug: debug, url: url)
        Self.language = language
        return self
    }
    
    //MARK:Controllers
    public static func controller(purchase:Como.Purchase, delegate:ComoDelegate) -> UINavigationController {
        let nav = ComoController.make(delegate:delegate)
        Como.shared.currentSale = CurrentSale(purchase: purchase, customer:Como.shared.currentSale?.customer)
        nav.modalPresentationStyle = .formSheet
        return nav
    }
    
    public static func payController(purchase:Como.Purchase, amount:Int, delegate:ComoDelegate) -> UINavigationController {
        if Como.shared.currentSale?.customer == nil {            
            let nav = ComoController.make(delegate:delegate)
            (nav.children.first as? ComoController)?.nextAction = .pay(amount: amount)
            Como.shared.currentSale = CurrentSale(purchase: purchase)
            nav.modalPresentationStyle = .formSheet
            return nav
        }
        let payVc:ComoPayController = SBController("Como", "pay")
        payVc.amount = amount
        payVc.delegate = delegate
        let nav = UINavigationController(rootViewController: payVc)
        nav.modalPresentationStyle = .formSheet
        return nav
    }
    
    public func endTransaction(){
        transactionUuid = UUID().uuidString
    }
    
    //MARK: - Methods
    public func getMemberDetails(customer:Customer, purchase:Purchase) async throws -> MemberDetailsResponse{
        try validateInitialized()
        
        struct MemberDetails : Codable {
            let customer:Customer
            let purchase:Purchase
        }
        
        let object = MemberDetails(customer: customer, purchase: purchase)
                      
        return try await api!.post("getMemberDetails?returnAssets=active&expand=assets.redeemable", object:object)
    }
    
    public func getBenefits(customers:[Customer], purchase:Purchase, redeemAssets:[RedeemAsset]) async throws -> GetBenefitsResponse {
        
        try validateInitialized()
        
        struct GetBenefits : Codable {
            let customers:[Customer]
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]
        }
        
        let object = GetBenefits(customers: customers, purchase: purchase, redeemAssets:redeemAssets)
                      
        return try await api!.post("getBenefits?expand=discountByDiscount", object:object)
    }
    
    /**
     When sending the pay request without the code, it will send  a SMS
     the we can call it again with the code to perform it
        > If no enough balance it will return less amount 
     */
    public func payment(customer:Customer, purchase:Purchase, amount:Int, code:String? = nil) async throws -> PaymentResponse {
        
        try validateInitialized()
        
        struct Payment : Codable {
            let customer:Customer
            let purchase:Purchase
            let verificationCode:String?
            let amount:Int
        }
        
        let object = Payment(customer: customer, purchase: purchase, verificationCode:code, amount:amount)
                      
        return try await api!.post("payment", object:object)
    }
    
    public func cancelPayment(confirmation:String) async throws -> CancelPaymentResponse {
        try validateInitialized()
        
        struct CancelPayment : Codable {
            let confirmation:String
        }
        
        let object = CancelPayment(confirmation: confirmation)
                      
        return try await api!.post("cancelPayment", object:object)        
    }
    
    public func cancelPurchase(confirmation:String) async throws -> CancelPurchaseResponse {
        try validateInitialized()
        
        struct CancelPurchase : Codable {
            let confirmation:String
        }
        
        let object = CancelPurchase(confirmation: confirmation)
                      
        return try await api!.post("cancelPurchase", object:object)
    }
    
    public func submit(purchase:Como.Purchase, customers:[Como.Customer]? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil, closed:Bool = false) async throws -> Como.SubmitPurchaseResponse {
        
        try validateInitialized()

        defer {
            endTransaction()
        }

        struct SubmitPurchase:Codable {
            let customers:[Customer]?
            let purchase:Purchase
            let redeemAssets:[RedeemAsset]?
            let deals:[RedeemAsset]?
        }
        let append = closed ? "" : "?status=open"
        return try await api!.post("submitPurchase" + append, object:SubmitPurchase(customers:customers, purchase: purchase, redeemAssets: assets, deals: deals))
    }
    
    @discardableResult
    public func submit(purchase:Como.Purchase, customers:[Como.Customer]? = nil, assets:[RedeemAsset]? = nil, deals:[RedeemAsset]? = nil) async throws -> Como.SubmitPurchaseResponse {
        return try await submit(purchase: purchase, customers: customers, assets: assets, deals: deals, closed: true)
    }
    
    @discardableResult
    public func void(purchase:Como.Purchase) async throws -> Como.Api.Response {
        
        try validateInitialized()
        
        struct VoidPurchase : Codable {
            let purchase:Purchase
        }
        
        return try await api!.post("voidPurchase", object:VoidPurchase(purchase: purchase))
    }
    
    @discardableResult
    public func sendIdentificationCode(phoneNumber:String) async throws -> Como.Api.Response {
        try validateInitialized()
        
        struct SendAuthCode : Codable {
            let customer:Customer
        }
        
        let object = SendAuthCode(customer: Como.Customer(phoneNumber:phoneNumber))
        
        return try await api!.post("advanced/sendIdentificationCode", object:object)
    }
    
    @discardableResult
    public func quickRegister(customer:Como.Customer, authCode:String? = nil) async throws -> MemberDetailsResponse {
                
        try validateInitialized()
        
        struct QuickRegister : Codable {
            let customer:Customer
            let quickRegistrationCode:String?
        }
        
        let object = QuickRegister(customer: customer, quickRegistrationCode: authCode)
        
        return try await api!.post("advanced/registration/quick", object:object)
    }
    
    public func submitEvent() async throws -> Como.Api.Response {
        try validateInitialized()
        return try await api!.post("submitEvent")
    }
    
    private func validateInitialized() throws{
        guard isInitialized else {
            throw Como.Api.ResponseErrorCode.sdkNotSettedUp
        }
    }
    
    public var isInitialized: Bool {
        api != nil
    }
    
    static func trans(_ key:String) -> String{
        NSLocalizedString(key, tableName: Self.language, comment: "")
    }
}
