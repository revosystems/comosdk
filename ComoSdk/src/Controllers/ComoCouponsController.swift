import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorsLabel: UILabel!
    
    @IBOutlet var headerImageView: UIView!
    @IBOutlet var redeemButton: UIButton!
    
    @IBOutlet private weak var couponCodeTitle:UILabel!
    @IBOutlet private weak var couponCodeDescLabel:UILabel!
    
    override func viewDidLoad() {
        loading.isHidden = true
        errorsLabel.text = nil
        appearance()
        translate()
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true)
    }
    
    func appearance(){
        headerImageView.circle()
        redeemButton.round(4)
    }
    
    func translate(){
        couponCodeTitle.text = Como.trans("como_couponCodes")
        couponCodeDescLabel.text = Como.trans("como_couponCodesDesc")
        redeemButton.setTitle(Como.trans("como_redeem"), for: .normal)
        textField.placeholder = Como.trans("como_coupon_placeholder")
        #if DEBUG
        textField.text = "682105"
        #endif
    }
}

