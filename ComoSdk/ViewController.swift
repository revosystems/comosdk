import UIKit

class ViewController: UIViewController, ComoDelegate {
    
    var benefits:Como.GetBenefitsResponse?
    var customer:Como.Customer?
    
    let purchase = Como.Purchase.fake()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Como.shared.setup(key: "b1ad7faa", branchId: "comosdk-test", posId: "1", source: "ComoSwiftSDK", sourceVersion: "0.0.1", debug: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showComoController(nil)
    }

    @IBAction func showComoController(_ sender: UIButton?) {
        let nav = Como.controller(purchase: purchase, delegate: self)
        present(nav, animated: true)
    }
    
    @IBAction func submitThePurchase(_ sender: UIButton?) {
        
        let assets = benefits?.redeemAssets?.map { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:nil)}
        let deals  = benefits?.deals?.map { Como.RedeemAsset(key: $0.key, appliedAmount: 0, code:nil) }
        
        Task {
            do {
                let response = try await Como.shared.submit(purchase: Como.Purchase.fake(), customer:customer, assets: assets, deals: deals)
                print("OK")
            }catch{
                print("Error")
            }
        }
    }
    
    func como(onBenefitsSelected benefits: Como.GetBenefitsResponse, customer:Como.Customer) {
        self.benefits = benefits
    }
    
}

