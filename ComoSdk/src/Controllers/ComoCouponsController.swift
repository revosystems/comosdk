import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var purchase:Como.Purchase!
    var customer:Como.Customer?
    var delegate:ComoDelegate?
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        let assets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.como(onRedeemAssetsSelected: assets, customer:self.customer)
        }
    }
}

