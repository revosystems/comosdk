import UIKit
import RevoFoundation

public protocol ComoDelegate {
    func como(onBenefitsSelected benefits:Como.GetBenefitsResponse, customer:Como.Customer)
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
    
    @IBAction func onFindMemberPressed(_ sender: Any?) {
        guard let customer = customer() else {
            return inputField.shake()
        }
        loading.start(findMemberButton)
        
        Como.shared.getMemberDetails(customer: customer, purchase: purchase) { [weak self] result in
            guard let self = self else { return }
            self.loading.stop(self.findMemberButton)
            switch result {
            case .failure(let error)   : self.onError(error)
            case .success(let details) : self.onMemberFetched(details: details)
            }
        }
    }
    
    @IBAction func onRegisterPressed(_ sender: UIButton?) {
        loading.start(sender)
        Como.shared.quickRegister(phoneNumber: inputField.text!) { [weak self] result in
            guard let self = self else { return }
            self.loading.stop(sender)
            switch result {
            case .failure(let error)   : self.onError(error)
            case .success : self.onFindMemberPressed(self.findMemberButton)
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
        Como.shared.void(purchase: purchase) { result in
            print("Voided")
        }
    }
    
    deinit {
        delegate = nil
    }
}
