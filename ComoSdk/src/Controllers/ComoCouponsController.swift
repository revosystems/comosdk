import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var delegate:ComoDelegate?
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        let assets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.como(onRedeemAssetsSelected: assets, customer:Como.shared.currentSale!.customer)
        }
    }
}

