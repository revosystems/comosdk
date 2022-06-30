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
    }
}
