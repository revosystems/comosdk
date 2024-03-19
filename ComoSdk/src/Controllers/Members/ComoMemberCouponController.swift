import Foundation
import UIKit
import RevoUIComponents

class ComoMemberCouponController : UIViewController {
 
    @IBOutlet private weak var button:AsyncButton!
    @IBOutlet private weak var input:UITextField!
    
    
    override func viewDidLoad() {
        button.round(4)
        button.setTitle(Como.trans("como_apply"), for: .normal)
    }
    
    @IBAction func onButtonPressed(_ button:UIButton){
        
        guard (input.text?.count ?? 0) > 2 else {
            return input.shake()
        }
            
        Como.shared.currentSale?.redeemAssets = [Como.RedeemAsset(key: nil, appliedAmount: nil, code:input.text!)]
        
        dismiss(animated: true)
        
    }
}
