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
        Task {
            do {
                try await Como.shared.currentSale?.getBenefits()
                let response = try await Como.shared.currentSale?.submit(closed:true)
                print("OK")
            } catch {
                print("Error")
            }
        }
    }
    
    @IBAction func onPayPressed(_ sender: Any) {
        let nav = Como.payController(purchase: purchase, amount:100, delegate: self)
        present(nav, animated: true)
    }
    
    func como(onCustomerSelected currentSale: Como.CurrentSale) {
        print("On customer selected")
    }
    
    func como(onPaid amount:Int){
       print("On paid")
    }
    
    func comoActionCanceled() {
        print("On action canceled")
    }
    
}

