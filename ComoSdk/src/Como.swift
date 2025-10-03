import Foundation
import UIKit
import RevoFoundation

public class Como {
    
    public enum Feature {
        case coupons
        case customIdentifier
    }
    
    public static var language:String = "es"
    
    public static var pointsName: String?
    public static var creditsName: String?
    
    public static var shared:Como = {
        Como()
    }()
    
    var api:Api?
    var transactionUuid:String = UUID().uuidString
    
    public var currentSale:CurrentSale?
    public var memberDetails:MemberDetailsResponse?
    
    @discardableResult
    public func setup(key:String, branchId:String, posId:String, source:String, sourceVersion:String, language:String = "es", pointsName:String? = nil, creditsName:String? = nil, debug:Bool = false, url:String = "https://api.prod.bcomo.com/api/v4/") -> Self {
        api = Api(key:key, branchId: branchId, posId: posId, source: source, sourceVersion: sourceVersion, debug: debug, url: url)
        Self.language = language
        Self.pointsName = pointsName
        Self.creditsName = creditsName
        return self
    }
    
    //MARK:Controllers
    public static func controller(purchase:Como.Purchase, customerId:String? = nil, delegate:ComoDelegate) -> UINavigationController {
        let nav = ComoController.make(delegate:delegate)
        
        var customer = Como.shared.currentSale?.customer
        if let customerId {
            customer = Como.Customer(commonExtId: customerId)
        }
        
        Como.shared.currentSale = CurrentSale(
            purchase: purchase,
            customer: customer
        )
        
        Task {
            try? await Como.shared.currentSale?.fetchCustomerDetails()
        }
        
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
        
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let payVc = sb.instantiateViewController(withIdentifier: "pay") as! ComoPayController
        
        payVc.amount = amount
        payVc.delegate = delegate
        let nav = UINavigationController(rootViewController: payVc)
        nav.modalPresentationStyle = .formSheet
        return nav
    }
    
    public func endTransaction(){
        transactionUuid = UUID().uuidString
    }
    
    //MARK: - Login user
    public func login(_ externalId:String, purchase:Purchase? = nil) async throws  {
        let customer = Como.Customer(commonExtId: externalId)
        let details = try await Como.shared.getMemberDetails(
            customer: customer,
            purchase: purchase
        )
        Como.shared.memberDetails = details
    }
    
    public func logout() {
        Como.shared.memberDetails = nil
    }
    
    //MARK: - Methods
    public func getMemberDetails(customer:Customer, purchase:Purchase?) async throws -> MemberDetailsResponse{
        try validateInitialized()

        
        struct MemberDetails : Codable {
            let customer:Customer
            let purchase:Purchase?
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
        
        let singleFieldCustomers = customers.compactMap {
            $0.singleIdentified()
        }
        
        let object = GetBenefits(customers: singleFieldCustomers, purchase: purchase, redeemAssets:redeemAssets)
                      
        return try await api!.post("getBenefits?expand=discountByDiscount", object:object)
    }
    
    /**
     When sending the pay request without the code, it will send  a SMS
     the we can call it again with the code to perform it
        > If no enough balance it will return less amount 
     */
    public func payment(customer:Customer, purchase:Purchase, amount:Int, code:String? = nil) async throws -> PaymentResponse {
        
        guard let singleIdentifiedCustomer = customer.singleIdentified() else {
            throw Api.ResponseErrorCode.needCustomer
        }
        
        try validateInitialized()
        
        struct Payment : Codable {
            let customer:Customer
            let purchase:Purchase
            let verificationCode:String?
            let amount:Int
        }
        
        let object = Payment(customer: singleIdentifiedCustomer, purchase: purchase, verificationCode:code, amount:amount)
                      
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
    public func sendIdentificationCode(customer:Como.Customer) async throws -> Como.Api.Response {
        try validateInitialized()
        
        struct SendAuthCode : Codable {
            let customer:Customer
        }
        
        let object = SendAuthCode(customer: customer)
        
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
    
    public func hasFeature(_ feature:Como.Feature) -> Bool {
        api?.url.contains("como") ?? false
    }
    
    static func trans(_ key:String) -> String{
        NSLocalizedString(key, tableName: Self.language, comment: "")
    }
}
