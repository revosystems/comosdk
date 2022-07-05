import UIKit

class ViewController: UIViewController, ComoDelegate {
    
    var benefits:Como.GetBenefitsResponse?
    var customer:Como.Customer?
    
    @IBOutlet weak var payCodeInput: UITextField!
    
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
            }catch{
                print("Error")
            }
        }
    }
    
    @IBAction func onPayPressed(_ sender: Any) {
        Task {
            do {
                try await Como.shared.currentSale?.pay(amount: 100, code: payCodeInput.text)
            }
            catch {
                print(error)
            }
        }
        
    }
    
    func como(onCustomerSelected currentSale: Como.CurrentSale) {
        
    }
    
}

