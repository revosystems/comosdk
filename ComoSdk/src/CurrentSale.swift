import Foundation

extension Como {
    
    public class CurrentSale {
        public var customer:Como.Customer?
        var purchase:Como.Purchase
        var redeemAssets:[Como.RedeemAsset]?
        
        var benefits:Como.GetBenefitsResponse?
     
        init(purchase:Como.Purchase, customer:Como.Customer? = nil){
            self.purchase = purchase
            self.customer = customer
            self.purchase.transactionId = Como.shared.transactionUuid
        }
        
        @discardableResult
        public func update(purchase:Como.Purchase) -> Self {
            self.purchase = purchase
            self.purchase.transactionId = Como.shared.transactionUuid
            return self
        }
        
        @discardableResult
        public func getBenefits() async throws -> Como.GetBenefitsResponse{
            let response = try await Como.shared.getBenefits(customers: (customer != nil) ? [customer!] : [], purchase: purchase, redeemAssets: redeemAssets ?? [])
            benefits = response
            return response
        }
        
        @discardableResult
        public func submit(closed:Bool) async throws -> SubmitPurchaseResponse {
            let assets = benefits?.redeemAssets?.map { Como.RedeemAsset(key: $0.key, appliedAmount: $0.benefits?.compactMap { $0.sum }.sum() ?? 0, code:$0.code) }
            let deals  = benefits?.deals?.map        { Como.RedeemAsset(key: $0.key, appliedAmount: $0.benefits?.compactMap { $0.sum }.sum() ?? 0, code:nil) }
            
            return try await Como.shared.submit(purchase: purchase, customers:customer != nil ? [customer!] : nil, assets: assets, deals: deals, closed: closed)
        }
        
        @discardableResult
        public func void() async throws -> Como.Api.Response {
            try await Como.shared.void(purchase: purchase)
        }
        
        func pay(amount:Int, code:String? = nil) async throws -> PaymentResponse {
            guard let customer = customer else {
                throw Como.Api.ResponseErrorCode.needCustomer
            }
            let response = try await Como.shared.payment(customer: customer, purchase: purchase, amount: amount, code: code)
            
            purchase.add(payments:response.payments.filter {
                $0.paymentMethod != "discount"
            }.map {
                MeanOfPayment(type: response.type, amount: $0.amount)
            })
            return response
        }
    }
}
