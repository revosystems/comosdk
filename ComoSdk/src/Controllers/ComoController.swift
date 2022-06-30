import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onRedeemAssetsSelected assets:[Como.RedeemAsset], customer:Como.Customer?)
}

public class ComoController : UIViewController {
 
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var findMemberButton: UIButton!
    
    @IBOutlet weak var registerView: UIView!
    
    var delegate:ComoDelegate?
    var purchase:Como.Purchase!
    
    public static func make() -> UINavigationController {
        let nav:UINavigationController = SBController("Como", "nav")
        return nav
    }
        
    public override func viewDidLoad() {
        loading.isHidden = true
        errorLabel.text = ""
        registerView.isHidden = true
        findMemberButton.round(4)
    }
    
    @IBAction func onFindMemberPressed(_ sender: UIButton?) {
        guard let customer = customer() else {
            return inputField.shake()
        }
        loading.start(findMemberButton)
        
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(customer: customer, purchase: purchase)
                loading.stop(self.findMemberButton)
                onMemberFetched(details: details)
            } catch {
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    @IBAction func onRegisterPressed(_ sender: UIButton?) {
        loading.start(sender)
        Task {
            do {
                try await Como.shared.quickRegister(phoneNumber: inputField.text!)
                loading.stop(sender)
                onFindMemberPressed(self.findMemberButton)
            }catch{
                loading.stop(sender)
                onError(error)
            }
        }
    }
    
    func onError(_ error:Error){
        registerView.isHidden = false
        errorLabel.text = "\(error)"
    }
    
    func onMemberFetched(details:Como.MemberDetailsResponse){
        let vc:ComoMemberDetailsController = SBController("Como", "memberDetails")
        vc.details = details
        vc.delegate = delegate
        vc.purchase = purchase
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSendAuthCodePressed(_ sender: Any) {
    
    }
    
    @IBAction func onAddCouponCodePressed(_ sender: Any) {
        
    }
    
    func customer() -> Como.Customer? {
        guard inputField.text?.count ?? 0 > 0 else {
            return nil
        }
        
        if inputField.text!.contains("@") {
            return Como.Customer(phoneNumber:nil, email: inputField.text?.lowercased())
        }
        return Como.Customer(phoneNumber: inputField.text!.lowercased(), email:nil)
    }
    
    @IBAction func onVoidPurchasePressed(_ sender: Any) {
        Task {
            do {
                try await Como.shared.void(purchase: purchase)
                print("Voided")
            }catch{
                print(error)
            }
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coupons" {
            let vc = segue.destination as! ComoCouponsController
            vc.purchase = purchase
            vc.delegate = delegate
        }
    }
    
    deinit {
        delegate = nil
    }
}
