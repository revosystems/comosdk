import Foundation

extension Como {
    
    public class CurrentSale {
        var customer:Como.Customer?
        var purchase:Como.Purchase
        var redeemAssets:[Como.RedeemAsset]?
        
        var benefits:Como.GetBenefitsResponse?
     
        init(purchase:Como.Purchase){
            self.purchase = purchase
        }
        
        @discardableResult
        public func getBenefits() async throws -> Como.GetBenefitsResponse{
            let response = try await Como.shared.getBenefits(customers: (customer != nil) ? [customer!] : [], purchase: purchase, redeemAssets: redeemAssets ?? [])
            benefits = response
            return response
        }
        
        @discardableResult
        public func submit(closed:Bool) async throws -> SubmitPurchaseResponse {
            let assets = benefits?.redeemAssets?.map { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:$0.code) }
            let deals  = benefits?.deals?.map        { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:nil) }
            
            return try await Como.shared.submit(purchase: purchase, customer:customer, assets: assets, deals: deals, closed: closed)
        }
        
        @discardableResult
        public func void() async throws -> Como.Api.Response {
            return try await Como.shared.void(purchase: purchase)
        }
    }
}
