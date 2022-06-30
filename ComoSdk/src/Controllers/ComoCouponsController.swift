import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true)
    }
}

