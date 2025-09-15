import UIKit
import RevoUIComponents

class ComoLoginAddCouponController : UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var button: AsyncButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        textField.placeholder = Como.trans("como_coupon_placeholder")
        errorLabel.text = ""
        button.setTitle(Como.trans("como_search_customer"), for: .normal)
        button.round(4)
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true)
    }
}

