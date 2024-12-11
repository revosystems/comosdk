import Foundation
import UIKit
import RevoFoundation

protocol ComoRegisterDelegate : AnyObject {
    func como(registered: Como.MemberDetailsResponse)
}

class ComoRegisterController : UIViewController, ComoRegisterDelegate {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var byMailView: UIView!
    @IBOutlet var byPhoneView: UIView!
    
    @IBOutlet var segmented: UISegmentedControl!
    
    
    override func viewDidLoad() {
        onSegmentedChanged(segmented)
    }
    
    @IBAction func onSegmentedChanged(_ segmented:UISegmentedControl){
        if segmented.selectedSegmentIndex == 0 {
            byPhoneView.isHidden = false
            byMailView.isHidden = true
        } else {
            byPhoneView.isHidden = true
            byMailView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoRegisterByMailController)?.delegate = self
        (segue.destination as? ComoRegisterByPhoneController)?.delegate = self
    }
    
    func como(registered: Como.MemberDetailsResponse) {
        Como.shared.currentSale?.customer  = registered.membership.customer
        
        let sb = UIStoryboard(name: "Como", bundle: Bundle.module)
        let vc = sb.instantiateInitialViewController(withIdentifier: "memberDetails") as! ComoMemberDetailsController
        
        vc.details = registered
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
