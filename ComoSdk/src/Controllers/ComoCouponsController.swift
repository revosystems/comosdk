import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorsLabel: UILabel!
    
    override func viewDidLoad() {
        loading.isHidden = true
        errorsLabel.text = nil
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true)
    }
}

