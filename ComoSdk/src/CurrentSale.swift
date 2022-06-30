import Foundation

extension Como {
    
    class CurrentSale {
        var customer:Como.Customer?
        var purchase:Como.Purchase
        var redeemAssets:[Como.RedeemAsset]?
        
        var benefits:Como.GetBenefitsResponse?
     
        init(purchase:Como.Purchase){
            self.purchase = purchase
        }
        
        func getBenefits(assets:[Como.RedeemAsset]){
            Task {
                do{
                    let response = try await Como.shared.getBenefits(customers: (customer != nil) ? [customer!] : [], purchase: purchase, redeemAssets: assets)
                    benefits = response
                } catch {
                    print(error)
                }
            }
        }
        
        func submit() async throws -> SubmitPurchaseResponse {
            let assets = benefits?.redeemAssets?.map { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:nil)}
            let deals  = benefits?.deals?.map        { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:nil) }
            
            return try await Como.shared.submit(purchase: purchase, customer:customer, assets: assets, deals: deals)
        }
    }
}
