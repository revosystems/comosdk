import Foundation
import UIKit

class ComoCouponsController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var errorsLabel: UILabel!
    
    @IBOutlet var headerImageView: UIView!
    @IBOutlet var redeemButton: UIButton!
    
    override func viewDidLoad() {
        loading.isHidden = true
        errorsLabel.text = nil
        appearance()
    }
    
    @IBAction func onRedeemPressed(_ sender: Any) {
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:textField.text!)]
        dismiss(animated: true)
    }
    
    func appearance(){
        headerImageView.circle()
        redeemButton.round(4)
    }
}

