import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        let assets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            Como.shared.currentSale?.redeemAssets = assets
        }
    }
}

